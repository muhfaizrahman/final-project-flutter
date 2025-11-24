import '../repositories/favorite_repository.dart';

/// Use Case: Check if a movie is favorited by the current user
class IsFavorite {
  final FavoriteRepository repository;
  final String Function() getCurrentUserId;

  IsFavorite(this.repository, this.getCurrentUserId);

  Future<bool> call(int movieId) async {
    final userId = getCurrentUserId();
    if (userId.isEmpty) {
      return false;
    }
    return await repository.isFavorite(userId, movieId);
  }
}

