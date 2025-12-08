import '../../domain/entities/review_entity.dart';
import '../../domain/repositories/review_repository.dart';
import '../datasources/review_remote_datasource.dart';
import '../models/review_model.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource remoteDataSource;

  ReviewRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> addReview(String userId, int movieId, int rating, String comment) async {
    await remoteDataSource.addReview(userId, movieId, rating, comment);
  }

  @override
  Future<List<ReviewEntity>> getReviews(int movieId) async {
    final data = await remoteDataSource.getReviews(movieId);
    return data.map((json) => ReviewModel.fromJson(json)).toList();
  }
}