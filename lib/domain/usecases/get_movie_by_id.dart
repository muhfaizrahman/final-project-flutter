import '../entities/movie_entity.dart';
import '../repositories/movie_repository.dart';

/// Use Case: Get a single movie by ID
class GetMovieById {
  final MovieRepository repository;

  GetMovieById(this.repository);

  Future<MovieEntity?> call(int id) async {
    return await repository.getMovieById(id);
  }
}

