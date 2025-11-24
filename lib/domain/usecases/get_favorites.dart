import '../repositories/favorite_repository.dart';

/// Use Case: Get all favorite movie IDs for the current user
class GetFavorites {
  final FavoriteRepository repository;
  final String Function() getCurrentUserId;

  GetFavorites(this.repository, this.getCurrentUserId);

  Future<List<int>> call() async {
    final userId = getCurrentUserId();
    if (userId.isEmpty) {
      throw Exception('User not authenticated');
    }
    return await repository.getFavoriteMovieIds(userId);
  }
}

