import '../datasources/favorite_remote_datasource.dart';

class FavoriteRepository {
  final FavoriteRemoteDataSource _remoteDataSource;

  FavoriteRepository(this._remoteDataSource);

  /// Get all favorite movie IDs for the current user
  Future<List<int>> getFavoriteMovieIds(String userId) async {
    return await _remoteDataSource.getFavoriteMovieIds(userId);
  }

  /// Add a movie to favorites
  Future<void> addFavorite(String userId, int movieId) async {
    await _remoteDataSource.addFavorite(userId, movieId);
  }

  /// Remove a movie from favorites
  Future<void> removeFavorite(String userId, int movieId) async {
    await _remoteDataSource.removeFavorite(userId, movieId);
  }

  /// Toggle favorite status
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

  /// Check if a movie is favorited by the user
  Future<bool> isFavorite(String userId, int movieId) async {
    return await _remoteDataSource.isFavorite(userId, movieId);
  }
}

