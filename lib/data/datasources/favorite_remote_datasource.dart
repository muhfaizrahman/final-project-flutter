import 'package:supabase_flutter/supabase_flutter.dart';

class FavoriteRemoteDataSource {
  final SupabaseClient _supabase;

  FavoriteRemoteDataSource(this._supabase);

  /// Get all favorite movie IDs for the current user
  Future<List<int>> getFavoriteMovieIds(String userId) async {
    try {
      final response = await _supabase
          .from('favorites')
          .select('movie_id')
          .eq('user_id', userId);

      if (response == null) return [];

      return (response as List)
          .map((item) => item['movie_id'] as int)
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch favorite movie IDs: $e');
    }
  }

  /// Add a movie to favorites
  Future<void> addFavorite(String userId, int movieId) async {
    try {
      await _supabase.from('favorites').insert({
        'user_id': userId,
        'movie_id': movieId,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to add favorite: $e');
    }
  }

  /// Remove a movie from favorites
  Future<void> removeFavorite(String userId, int movieId) async {
    try {
      await _supabase
          .from('favorites')
          .delete()
          .eq('user_id', userId)
          .eq('movie_id', movieId);
    } catch (e) {
      throw Exception('Failed to remove favorite: $e');
    }
  }

  /// Check if a movie is favorited by the user
  Future<bool> isFavorite(String userId, int movieId) async {
    try {
      final response = await _supabase
          .from('favorites')
          .select()
          .eq('user_id', userId)
          .eq('movie_id', movieId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      throw Exception('Failed to check favorite status: $e');
    }
  }
}

