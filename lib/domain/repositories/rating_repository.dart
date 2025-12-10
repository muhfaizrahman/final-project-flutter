import '../entities/rating_entity.dart';

abstract class RatingRepository {
  Future<void> addRating(String userId, int movieId, int rating);
  Future<void> updateRating(String userId, int movieId, int rating);
  Future<void> deleteRating(String userId, int movieId);
  Future<RatingEntity?> getUserRating(String userId, int movieId);
  Future<List<RatingEntity>> getMovieRatings(int movieId);
}
