import 'package:supabase_flutter/supabase_flutter.dart';

class ReviewRemoteDataSource {
  final SupabaseClient _supabase;

  ReviewRemoteDataSource(this._supabase);

  Future<void> addReview(String userId, int movieId, int rating, String comment) async {
    await _supabase.from('reviews').insert({
      'user_id': userId,
      'movie_id': movieId,
      'rating': rating,
      'comment': comment,
    });
  }

  Future<List<Map<String, dynamic>>> getReviews(int movieId) async {
    final response = await _supabase
        .from('reviews')
        .select()
        .eq('movie_id', movieId)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }
}