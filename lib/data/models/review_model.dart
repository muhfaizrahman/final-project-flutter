import '../../domain/entities/review_entity.dart';

class ReviewModel extends ReviewEntity {
  const ReviewModel({
    required super.id,
    required super.userId,
    required super.movieId,
    required super.rating,
    required super.comment,
    required super.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      userId: json['user_id'],
      movieId: json['movie_id'],
      rating: json['rating'],
      comment: json['comment'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}