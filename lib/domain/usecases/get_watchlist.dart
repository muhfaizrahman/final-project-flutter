import '../../domain/repositories/watchlist_repository.dart';


class GetWatchlist {
  final WatchlistRepository repo;
  final String Function() getUserId;

  GetWatchlist(this.repo, this.getUserId);

  Future<List<int>> call() async {
    final uid = getUserId();
    if (uid.isEmpty) throw Exception('User not authenticated');
    return await repo.getWatchlistMovieIds(uid);
  }
}
