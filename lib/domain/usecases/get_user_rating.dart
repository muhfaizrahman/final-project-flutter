import '../entities/rating_entity.dart';
import '../repositories/rating_repository.dart';

class GetUserRating {
  final RatingRepository repository;

  GetUserRating(this.repository);

  Future<RatingEntity?> call(String userId, int movieId) async {
    return await repository.getUserRating(userId, movieId);
  }
}
