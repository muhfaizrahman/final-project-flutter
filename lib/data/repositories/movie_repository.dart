import '../../domain/entities/movie_entity.dart';
import '../../domain/repositories/movie_repository.dart' as domain;
import '../datasources/movie_remote_datasource.dart';
import '../models/movie_model.dart';

/// Repository implementation for movie operations
/// Implements the domain repository interface
class MovieRepository implements domain.MovieRepository {
  final MovieRemoteDataSource _remoteDataSource;

  MovieRepository(this._remoteDataSource);

  @override
  Future<List<MovieEntity>> getAllMovies() async {
    final data = await _remoteDataSource.getAllMovies();
    return MovieModel.fromJsonList(data).map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<MovieEntity>> getMoviesByCategory(String category) async {
    final data = await _remoteDataSource.getMoviesByCategory(category);
    return MovieModel.fromJsonList(data).map((model) => model.toEntity()).toList();
  }

  @override
  Future<MovieEntity?> getMovieById(int id) async {
    final data = await _remoteDataSource.getMovieById(id);
    if (data == null) return null;
    return MovieModel.fromJson(data).toEntity();
  }

  @override
  Future<List<MovieEntity>> getMoviesByIds(List<int> ids) async {
    if (ids.isEmpty) return [];
    final data = await _remoteDataSource.getMoviesByIds(ids);
    return MovieModel.fromJsonList(data).map((model) => model.toEntity()).toList();
  }
}

