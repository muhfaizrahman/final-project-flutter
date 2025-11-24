import '../entities/movie_entity.dart';
import '../repositories/movie_repository.dart';

/// Use Case: Get all movies from all categories
class GetAllMovies {
  final MovieRepository repository;

  GetAllMovies(this.repository);

  Future<List<MovieEntity>> call() async {
    return await repository.getAllMovies();
  }
}

