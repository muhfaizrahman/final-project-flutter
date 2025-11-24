import 'package:supabase_flutter/supabase_flutter.dart';

/// Remote Data Source for Movies
/// Handles direct communication with Supabase
class MovieRemoteDataSource {
  final SupabaseClient _supabase;

  MovieRemoteDataSource(this._supabase);

  /// Get all movies
  Future<List<Map<String, dynamic>>> getAllMovies() async {
    try {
      final response = await _supabase
          .from('movies')
          .select('''
            *,
            movie_genres (
              genres (
                name
              )
            )
          ''')
          .order('id', ascending: true);

      if (response == null) return [];

      return (response as List).cast<Map<String, dynamic>>();
    } catch (e) {
      throw Exception('Failed to fetch movies: $e');
    }
  }

  /// Get movies by category
  Future<List<Map<String, dynamic>>> getMoviesByCategory(String category) async {
    try {
      final response = await _supabase
          .from('movies')
          .select('''
            *,
            movie_genres (
              genres (
                name
              )
            )
          ''')
          .eq('category', category)
          .order('id', ascending: true);

      if (response == null) return [];

      return (response as List).cast<Map<String, dynamic>>();
    } catch (e) {
      throw Exception('Failed to fetch movies by category: $e');
    }
  }

  /// Get movie by ID
  Future<Map<String, dynamic>?> getMovieById(int id) async {
    try {
      final response = await _supabase
          .from('movies')
          .select('''
            *,
            movie_genres (
              genres (
                name
              )
            )
          ''')
          .eq('id', id)
          .maybeSingle();

      return response as Map<String, dynamic>?;
    } catch (e) {
      throw Exception('Failed to fetch movie by ID: $e');
    }
  }

  /// Get movies by IDs
  Future<List<Map<String, dynamic>>> getMoviesByIds(List<int> ids) async {
    try {
      if (ids.isEmpty) return [];

      final response = await _supabase
          .from('movies')
          .select('''
            *,
            movie_genres (
              genres (
                name
              )
            )
          ''')
          .filter('id', 'in', ids)
          .order('id', ascending: true);

      if (response == null) return [];

      return (response as List).cast<Map<String, dynamic>>();
    } catch (e) {
      throw Exception('Failed to fetch movies by IDs: $e');
    }
  }

}

