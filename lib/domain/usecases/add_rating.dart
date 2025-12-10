import '../repositories/rating_repository.dart';

class AddRating {
  final RatingRepository repository;

  AddRating(this.repository);

  Future<void> call(String userId, int movieId, int rating) async {
    if (rating < 1 || rating > 10) {
      throw Exception("Rating must be between 1 and 10");
    }
    return await repository.addRating(userId, movieId, rating);
  }
}
