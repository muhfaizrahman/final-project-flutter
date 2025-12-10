import 'package:supabase_flutter/supabase_flutter.dart';

class RatingRemoteDataSource {
  final SupabaseClient _supabase;

  RatingRemoteDataSource(this._supabase);

  /// Add a new rating
  Future<void> addRating(String userId, int movieId, int rating) async {
    await _supabase.from('ratings').insert({
      'user_id': userId,
      'movie_id': movieId,
      'rating': rating,
      'is_watched': true, // Auto-set watched when rating
    });
  }

  /// Update existing rating (using upsert for simplicity)
  Future<void> updateRating(String userId, int movieId, int rating) async {
    await _supabase
        .from('ratings')
        .update({'rating': rating})
        .eq('user_id', userId)
        .eq('movie_id', movieId);
  }

  /// Delete rating
  Future<void> deleteRating(String userId, int movieId) async {
    await _supabase
        .from('ratings')
        .delete()
        .eq('user_id', userId)
        .eq('movie_id', movieId);
  }

  /// Get user's rating for a specific movie
  Future<Map<String, dynamic>?> getUserRating(
    String userId,
    int movieId,
  ) async {
    final response = await _supabase
        .from('ratings')
        .select()
        .eq('user_id', userId)
        .eq('movie_id', movieId)
        .maybeSingle();

    return response;
  }

  /// Get all ratings for a movie
  Future<List<Map<String, dynamic>>> getMovieRatings(int movieId) async {
    final response = await _supabase
        .from('ratings')
        .select()
        .eq('movie_id', movieId)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }
}
