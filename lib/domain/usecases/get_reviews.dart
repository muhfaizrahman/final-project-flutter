import '../entities/review_entity.dart';
import '../repositories/review_repository.dart';

class GetReviews {
  final ReviewRepository repository;
  GetReviews(this.repository);

  Future<List<ReviewEntity>> call(int movieId) async {
    return await repository.getReviews(movieId);
  }
}