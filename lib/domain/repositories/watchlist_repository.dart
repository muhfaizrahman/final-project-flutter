abstract class WatchlistRepository {
  Future<List<int>> getWatchlistMovieIds(String userId);
  Future<void> addWatchlist(String userId, int movieId);
  Future<void> removeWatchlist(String userId, int movieId);
  Future<bool> toggleWatchlist(String userId, int movieId);
  Future<bool> isInWatchlist(String userId, int movieId);
}
