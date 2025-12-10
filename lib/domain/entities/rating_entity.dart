class RatingEntity {
  final String id;
  final String userId;
  final int movieId;
  final int rating;
  final bool isWatched;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RatingEntity({
    required this.id,
    required this.userId,
    required this.movieId,
    required this.rating,
    required this.isWatched,
    required this.createdAt,
    required this.updatedAt,
  });
}
