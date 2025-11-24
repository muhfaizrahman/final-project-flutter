import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/datasources/favorite_remote_datasource.dart';
import '../../data/repositories/favorite_repository.dart';

class FavoriteProvider with ChangeNotifier {
  final FavoriteRepository _repository;
  final SupabaseClient _supabase;
  
  Set<int> _favoriteMovieIds = {};
  bool _isLoading = false;
  String? _error;

  FavoriteProvider()
      : _supabase = Supabase.instance.client,
        _repository = FavoriteRepository(
          FavoriteRemoteDataSource(Supabase.instance.client),
        );

  Set<int> get favoriteMovieIds => _favoriteMovieIds;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Check if a movie is favorited
  bool isFavorite(int movieId) {
    return _favoriteMovieIds.contains(movieId);
  }

  /// Get current user ID
  String? get _currentUserId {
    return _supabase.auth.currentUser?.id;
  }

  /// Load favorite movie IDs for the current user
  Future<void> loadFavorites() async {
    final userId = _currentUserId;
    if (userId == null) {
      _error = 'User not authenticated';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final favoriteIds = await _repository.getFavoriteMovieIds(userId);
      _favoriteMovieIds = favoriteIds.toSet();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _favoriteMovieIds = {};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Toggle favorite status for a movie
  Future<void> toggleFavorite(int movieId) async {
    final userId = _currentUserId;
    if (userId == null) {
      _error = 'User not authenticated';
      notifyListeners();
      return;
    }

    _error = null;
    notifyListeners();

    try {
      final isFav = isFavorite(movieId);
      
      // Optimistic update
      if (isFav) {
        _favoriteMovieIds.remove(movieId);
      } else {
        _favoriteMovieIds.add(movieId);
      }
      notifyListeners();

      // Update in database
      final newStatus = await _repository.toggleFavorite(userId, movieId);
      
      // Update local state based on actual result
      if (newStatus) {
        _favoriteMovieIds.add(movieId);
      } else {
        _favoriteMovieIds.remove(movieId);
      }
      
      _error = null;
    } catch (e) {
      // Revert optimistic update on error
      final isFav = _favoriteMovieIds.contains(movieId);
      if (isFav) {
        _favoriteMovieIds.remove(movieId);
      } else {
        _favoriteMovieIds.add(movieId);
      }
      _error = e.toString();
    } finally {
      notifyListeners();
    }
  }

  /// Initialize favorites when user logs in
  void initialize() {
    loadFavorites();
  }

  /// Clear favorites when user logs out
  void clear() {
    _favoriteMovieIds.clear();
    _error = null;
    notifyListeners();
  }
}

