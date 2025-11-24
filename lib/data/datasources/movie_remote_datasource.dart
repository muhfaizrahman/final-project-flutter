import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/movie.dart';

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

  /// Convert database response to Movie model
  static Movie mapToMovie(Map<String, dynamic> data) {
    // Extract genres from nested structure
    List<String>? genres;
    if (data['movie_genres'] != null && data['movie_genres'] is List) {
      final genreList = data['movie_genres'] as List;
      genres = genreList
          .map((mg) => mg['genres']?['name'] as String?)
          .whereType<String>()
          .toList();
    }

    // Handle rating_average (can be double or null)
    double? ratingAverage;
    if (data['rating_average'] != null) {
      if (data['rating_average'] is num) {
        ratingAverage = (data['rating_average'] as num).toDouble();
      }
    }

    // Handle release_date (can be string or null)
    String? releaseDate;
    if (data['release_date'] != null) {
      releaseDate = data['release_date'].toString();
    }

    return Movie(
      id: data['id'] as int,
      title: data['title'] as String,
      overview: data['overview'] as String,
      posterPath: data['poster_path'] as String,
      ratingAverage: ratingAverage,
      releaseDate: releaseDate,
      genres: genres,
    );
  }

  /// Convert list of database responses to Movie models
  static List<Movie> mapToMovies(List<Map<String, dynamic>> dataList) {
    return dataList.map((data) => mapToMovie(data)).toList();
  }
}

