import '../repositories/rating_repository.dart';

class DeleteRating {
  final RatingRepository repository;

  DeleteRating(this.repository);

  Future<void> call(String userId, int movieId) async {
    return await repository.deleteRating(userId, movieId);
  }
}
