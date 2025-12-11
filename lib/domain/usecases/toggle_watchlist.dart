import '../repositories/watchlist_repository.dart';

class ToggleWatchlist {
  final WatchlistRepository repo;
  final String Function() getUserId;

  ToggleWatchlist(this.repo, this.getUserId);

  Future<bool> call(int movieId) async {
    final uid = getUserId();
    if (uid.isEmpty) throw Exception('User not authenticated');
    return await repo.toggleWatchlist(uid, movieId);
  }
}
