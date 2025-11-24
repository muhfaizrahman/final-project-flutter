import '../entities/movie_entity.dart';
import '../repositories/movie_repository.dart';

/// Use Case: Get multiple movies by their IDs
class GetMoviesByIds {
  final MovieRepository repository;

  GetMoviesByIds(this.repository);

  Future<List<MovieEntity>> call(List<int> ids) async {
    if (ids.isEmpty) return [];
    return await repository.getMoviesByIds(ids);
  }
}

