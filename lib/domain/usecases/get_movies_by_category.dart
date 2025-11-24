import '../entities/movie_entity.dart';
import '../repositories/movie_repository.dart';

/// Use Case: Get movies by category
/// Categories: 'now_showing', 'upcoming', 'top_rated'
class GetMoviesByCategory {
  final MovieRepository repository;

  GetMoviesByCategory(this.repository);

  Future<List<MovieEntity>> call(String category) async {
    return await repository.getMoviesByCategory(category);
  }
}

