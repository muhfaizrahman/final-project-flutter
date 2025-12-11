class WatchlistItem {
  final int id;
  final String userId;
  final int movieId;
  final String title;
  final String poster;
  final String category;

  WatchlistItem({
    required this.id,
    required this.userId,
    required this.movieId,
    required this.title,
    required this.poster,
    required this.category,
  });
}
