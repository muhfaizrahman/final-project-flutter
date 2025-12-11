import '../repositories/watchlist_repository.dart';

class IsInWatchlist {
  final WatchlistRepository repo;
  final String Function() getUserId;

  IsInWatchlist(this.repo, this.getUserId);

  Future<bool> call(int movieId) async {
    final uid = getUserId();
    if (uid.isEmpty) return false;
    return await repo.isInWatchlist(uid, movieId);
  }
}
