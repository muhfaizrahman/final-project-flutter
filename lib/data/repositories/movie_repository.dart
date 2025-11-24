import '../../models/movie.dart';
import '../datasources/movie_remote_datasource.dart';

/// Repository to manage movie data from Supabase
class MovieRepository {
  final MovieRemoteDataSource _remoteDataSource;

  MovieRepository(this._remoteDataSource);

  /// Get all available movies from all categories
  Future<List<Movie>> getAllMovies() async {
    final data = await _remoteDataSource.getAllMovies();
    return MovieRemoteDataSource.mapToMovies(data);
  }

  /// Get movies by category
  Future<List<Movie>> getMoviesByCategory(String category) async {
    final data = await _remoteDataSource.getMoviesByCategory(category);
    return MovieRemoteDataSource.mapToMovies(data);
  }

  /// Get a movie by ID
  Future<Movie?> getMovieById(int id) async {
    final data = await _remoteDataSource.getMovieById(id);
    if (data == null) return null;
    return MovieRemoteDataSource.mapToMovie(data);
  }

  /// Get movies by IDs
  Future<List<Movie>> getMoviesByIds(List<int> ids) async {
    if (ids.isEmpty) return [];
    final data = await _remoteDataSource.getMoviesByIds(ids);
    return MovieRemoteDataSource.mapToMovies(data);
  }
}

