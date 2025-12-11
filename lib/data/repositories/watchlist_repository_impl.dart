import '../../domain/repositories/watchlist_repository.dart';
import '../datasources/watchlist_remote_datasource.dart';

class WatchlistRepositoryImpl implements WatchlistRepository {
  final WatchlistRemoteDataSource _remote;

  WatchlistRepositoryImpl(this._remote);

  @override
  Future<List<int>> getWatchlistMovieIds(String userId) {
    return _remote.getWatchlistMovieIds(userId);
  }

  @override
  Future<void> addWatchlist(String userId, int movieId) {
    return _remote.addWatchlist(userId, movieId);
  }

  @override
  Future<void> removeWatchlist(String userId, int movieId) {
    return _remote.removeWatchlist(userId, movieId);
  }

  @override
  Future<bool> toggleWatchlist(String userId, int movieId) async {
    final isSaved = await _remote.isInWatchlist(userId, movieId);
    if (isSaved) {
      await _remote.removeWatchlist(userId, movieId);
      return false;
    } else {
      await _remote.addWatchlist(userId, movieId);
      return true;
    }
  }

  @override
  Future<bool> isInWatchlist(String userId, int movieId) {
    return _remote.isInWatchlist(userId, movieId);
  }
}
