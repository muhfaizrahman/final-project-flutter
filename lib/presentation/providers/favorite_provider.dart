import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/usecases/get_favorites.dart';
import '../../domain/usecases/toggle_favorite.dart';
import '../../domain/usecases/is_favorite.dart';

/// Presentation Layer Provider for Favorites
/// Uses Use Cases from Domain Layer
class FavoriteProvider with ChangeNotifier {
  final GetFavorites _getFavorites;
  final ToggleFavorite _toggleFavorite;
  final IsFavorite _isFavorite;
  final SupabaseClient _supabase;
  
  Set<int> _favoriteMovieIds = {};
  bool _isLoading = false;
  String? _error;

  FavoriteProvider({
    required GetFavorites getFavorites,
    required ToggleFavorite toggleFavorite,
    required IsFavorite isFavorite,
    required SupabaseClient supabaseClient,
  })  : _getFavorites = getFavorites,
        _toggleFavorite = toggleFavorite,
        _isFavorite = isFavorite,
        _supabase = supabaseClient;

  Set<int> get favoriteMovieIds => _favoriteMovieIds;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Check if a movie is favorited
  bool isFavorite(int movieId) {
    return _favoriteMovieIds.contains(movieId);
  }

  /// Get current user ID
  String getCurrentUserId() {
    final userId = _supabase.auth.currentUser?.id;
    return userId ?? '';
  }

  /// Load favorite movie IDs for the current user
  Future<void> loadFavorites() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final favoriteIds = await _getFavorites();
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

      // Update in database via use case
      final newStatus = await _toggleFavorite(movieId);
      
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
