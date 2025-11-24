import '../entities/movie_entity.dart';

/// Repository interface for movie operations
/// This is part of the Domain Layer and defines the contract
/// Implementation will be in the Data Layer
abstract class MovieRepository {
  /// Get all movies from all categories
  Future<List<MovieEntity>> getAllMovies();

  /// Get movies by category
  /// Categories: 'now_showing', 'upcoming', 'top_rated'
  Future<List<MovieEntity>> getMoviesByCategory(String category);

  /// Get a single movie by ID
  Future<MovieEntity?> getMovieById(int id);

  /// Get multiple movies by their IDs
  Future<List<MovieEntity>> getMoviesByIds(List<int> ids);
}

