import '../entities/review_entity.dart';

abstract class ReviewRepository {
  Future<void> addReview(String userId, int movieId, int rating, String comment);
  Future<List<ReviewEntity>> getReviews(int movieId);
}