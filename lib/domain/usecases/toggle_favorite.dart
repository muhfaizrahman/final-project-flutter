import '../repositories/favorite_repository.dart';

/// Use Case: Toggle favorite status for a movie
/// Returns true if added to favorites, false if removed
class ToggleFavorite {
  final FavoriteRepository repository;
  final String Function() getCurrentUserId;

  ToggleFavorite(this.repository, this.getCurrentUserId);

  Future<bool> call(int movieId) async {
    final userId = getCurrentUserId();
    if (userId.isEmpty) {
      throw Exception('User not authenticated');
    }
    return await repository.toggleFavorite(userId, movieId);
  }
}

