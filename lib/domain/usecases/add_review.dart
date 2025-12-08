import '../repositories/review_repository.dart';

class AddReview {
  final ReviewRepository repository;
  AddReview(this.repository);

  Future<void> call(String userId, int movieId, int rating, String comment) async {
    return await repository.addReview(userId, movieId, rating, comment);
  }
}