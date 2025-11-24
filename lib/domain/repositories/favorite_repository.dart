/// Repository interface for favorite operations
/// This is part of the Domain Layer and defines the contract
/// Implementation will be in the Data Layer
abstract class FavoriteRepository {
  /// Get all favorite movie IDs for a user
  Future<List<int>> getFavoriteMovieIds(String userId);

  /// Add a movie to favorites
  Future<void> addFavorite(String userId, int movieId);

  /// Remove a movie from favorites
  Future<void> removeFavorite(String userId, int movieId);

  /// Toggle favorite status
  /// Returns true if added, false if removed
  Future<bool> toggleFavorite(String userId, int movieId);

  /// Check if a movie is favorited by the user
  Future<bool> isFavorite(String userId, int movieId);
}

