import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/rating_entity.dart';
import '../../domain/usecases/add_rating.dart';
import '../../domain/usecases/update_rating.dart';
import '../../domain/usecases/delete_rating.dart';
import '../../domain/usecases/get_user_rating.dart';
import '../../domain/usecases/get_movie_ratings.dart';

class RatingProvider with ChangeNotifier {
  final AddRating _addRating;
  final UpdateRating _updateRating;
  final DeleteRating _deleteRating;
  final GetUserRating _getUserRating;
  final GetMovieRatings _getMovieRatings;
  final SupabaseClient _supabase;

  // Store user ratings per movie (indexed by movie_id)
  final Map<int, RatingEntity> _userRatings = {};
  List<RatingEntity> _movieRatings = [];
  bool _isLoading = false;
  String? _error;

  RatingProvider({
    required AddRating addRating,
    required UpdateRating updateRating,
    required DeleteRating deleteRating,
    required GetUserRating getUserRating,
    required GetMovieRatings getMovieRatings,
    required SupabaseClient supabaseClient,
  }) : _addRating = addRating,
       _updateRating = updateRating,
       _deleteRating = deleteRating,
       _getUserRating = getUserRating,
       _getMovieRatings = getMovieRatings,
       _supabase = supabaseClient;

  // Get user rating for specific movie
  RatingEntity? getUserRatingForMovie(int movieId) => _userRatings[movieId];

  // For backward compatibility with detail page (uses last loaded movie ratings)
  RatingEntity? get userRating =>
      _movieRatings.isEmpty ? null : _userRatings[_movieRatings.first.movieId];

  List<RatingEntity> get movieRatings => _movieRatings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Get average rating for a movie
  double? get averageRating {
    if (_movieRatings.isEmpty) return null;
    final sum = _movieRatings.fold<int>(
      0,
      (prev, rating) => prev + rating.rating,
    );
    return sum / _movieRatings.length;
  }

  /// Load current user's rating for a movie
  Future<void> loadUserRating(int movieId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      return;
    }

    try {
      final rating = await _getUserRating(userId, movieId);
      if (rating != null) {
        _userRatings[movieId] = rating;
      } else {
        _userRatings.remove(movieId);
      }
      notifyListeners();
    } catch (e) {
      // Silently fail for list items
      print('Error loading rating for movie $movieId: $e');
    }
  }

  /// Load all ratings for a movie
  Future<void> loadMovieRatings(int movieId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _movieRatings = await _getMovieRatings(movieId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add or update rating
  Future<void> submitRating(int movieId, int rating) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception("User not logged in");

    try {
      final existingRating = _userRatings[movieId];

      if (existingRating == null) {
        // Add new rating
        await _addRating(userId, movieId, rating);
      } else {
        // Update existing rating
        await _updateRating(userId, movieId, rating);
      }

      // Reload ratings
      await loadUserRating(movieId);
      await loadMovieRatings(movieId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// Delete rating
  Future<void> removeRating(int movieId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception("User not logged in");

    try {
      await _deleteRating(userId, movieId);
      _userRatings.remove(movieId);

      // Reload ratings
      await loadMovieRatings(movieId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
