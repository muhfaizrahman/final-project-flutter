class ReviewEntity {
  final String id;
  final String userId;
  final int movieId;
  final int rating;
  final String comment;
  final DateTime createdAt;

  const ReviewEntity({
    required this.id,
    required this.userId,
    required this.movieId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });
}