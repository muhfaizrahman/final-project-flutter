import '../../domain/repositories/favorite_repository.dart' as domain;
import '../datasources/favorite_remote_datasource.dart';

/// Repository implementation for favorite operations
/// Implements the domain repository interface
class FavoriteRepository implements domain.FavoriteRepository {
  final FavoriteRemoteDataSource _remoteDataSource;

  FavoriteRepository(this._remoteDataSource);

  @override
  Future<List<int>> getFavoriteMovieIds(String userId) async {
    return await _remoteDataSource.getFavoriteMovieIds(userId);
  }

  @override
  Future<void> addFavorite(String userId, int movieId) async {
    await _remoteDataSource.addFavorite(userId, movieId);
  }

  @override
  Future<void> removeFavorite(String userId, int movieId) async {
    await _remoteDataSource.removeFavorite(userId, movieId);
  }

  @override
  Future<bool> toggleFavorite(String userId, int movieId) async {
    final isFav = await _remoteDataSource.isFavorite(userId, movieId);
    if (isFav) {
      await _remoteDataSource.removeFavorite(userId, movieId);
      return false;
    } else {
      await _remoteDataSource.addFavorite(userId, movieId);
      return true;
    }
  }

  @override
  Future<bool> isFavorite(String userId, int movieId) async {
    return await _remoteDataSource.isFavorite(userId, movieId);
  }
}

