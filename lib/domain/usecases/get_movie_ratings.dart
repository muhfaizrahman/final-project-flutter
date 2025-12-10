import '../entities/rating_entity.dart';
import '../repositories/rating_repository.dart';

class GetMovieRatings {
  final RatingRepository repository;

  GetMovieRatings(this.repository);

  Future<List<RatingEntity>> call(int movieId) async {
    return await repository.getMovieRatings(movieId);
  }
}
