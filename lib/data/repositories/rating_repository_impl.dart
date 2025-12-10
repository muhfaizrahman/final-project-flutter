import '../../domain/entities/rating_entity.dart';
import '../../domain/repositories/rating_repository.dart';
import '../datasources/rating_remote_datasource.dart';
import '../models/rating_model.dart';

class RatingRepositoryImpl implements RatingRepository {
  final RatingRemoteDataSource remoteDataSource;

  RatingRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> addRating(String userId, int movieId, int rating) async {
    await remoteDataSource.addRating(userId, movieId, rating);
  }

  @override
  Future<void> updateRating(String userId, int movieId, int rating) async {
    await remoteDataSource.updateRating(userId, movieId, rating);
  }

  @override
  Future<void> deleteRating(String userId, int movieId) async {
    await remoteDataSource.deleteRating(userId, movieId);
  }

  @override
  Future<RatingEntity?> getUserRating(String userId, int movieId) async {
    final data = await remoteDataSource.getUserRating(userId, movieId);
    if (data == null) return null;
    return RatingModel.fromJson(data);
  }

  @override
  Future<List<RatingEntity>> getMovieRatings(int movieId) async {
    final data = await remoteDataSource.getMovieRatings(movieId);
    return data.map((json) => RatingModel.fromJson(json)).toList();
  }
}
