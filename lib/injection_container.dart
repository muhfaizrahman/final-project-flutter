import 'package:final_project/data/datasources/review_remote_datasource.dart';
import 'package:final_project/domain/repositories/review_repository.dart';
import 'package:final_project/domain/usecases/add_review.dart';
import 'package:final_project/domain/usecases/get_reviews.dart';
import 'package:final_project/presentation/providers/review_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'data/datasources/favorite_remote_datasource.dart';
import 'data/datasources/movie_remote_datasource.dart';
import 'data/repositories/favorite_repository.dart';
import 'data/repositories/movie_repository.dart';
import 'domain/usecases/get_all_movies.dart';
import 'domain/usecases/get_movies_by_category.dart';
import 'domain/usecases/get_movie_by_id.dart';
import 'domain/usecases/get_movies_by_ids.dart';
import 'domain/usecases/get_favorites.dart';
import 'domain/usecases/toggle_favorite.dart';
import 'domain/usecases/is_favorite.dart';
import 'presentation/providers/movie_provider.dart';
import 'presentation/providers/favorite_provider.dart';
import 'data/repositories/review_repository_impl.dart';

/// Dependency Injection Container
/// Sets up all dependencies following Clean Architecture
class InjectionContainer {
  static SupabaseClient get supabaseClient => Supabase.instance.client;

  // Data Sources
  static MovieRemoteDataSource get movieRemoteDataSource {
    return MovieRemoteDataSource(supabaseClient);
  }

  static FavoriteRemoteDataSource get favoriteRemoteDataSource {
    return FavoriteRemoteDataSource(supabaseClient);
  }

  // Repositories
  static MovieRepository get movieRepository {
    return MovieRepository(movieRemoteDataSource);
  }

  static FavoriteRepository get favoriteRepository {
    return FavoriteRepository(favoriteRemoteDataSource);
  }

  // Use Cases
  static GetAllMovies get getAllMovies {
    return GetAllMovies(movieRepository);
  }

  static GetMoviesByCategory get getMoviesByCategory {
    return GetMoviesByCategory(movieRepository);
  }

  static GetMovieById get getMovieById {
    return GetMovieById(movieRepository);
  }

  static GetMoviesByIds get getMoviesByIds {
    return GetMoviesByIds(movieRepository);
  }

  static GetFavorites get getFavorites {
    return GetFavorites(
      favoriteRepository,
      () => supabaseClient.auth.currentUser?.id ?? '',
    );
  }

  static ToggleFavorite get toggleFavorite {
    return ToggleFavorite(
      favoriteRepository,
      () => supabaseClient.auth.currentUser?.id ?? '',
    );
  }

  static IsFavorite get isFavorite {
    return IsFavorite(
      favoriteRepository,
      () => supabaseClient.auth.currentUser?.id ?? '',
    );
  }

  // Providers
  static MovieProvider get movieProvider {
    return MovieProvider(
      getAllMovies: getAllMovies,
      getMoviesByCategory: getMoviesByCategory,
      getMovieById: getMovieById,
      getMoviesByIds: getMoviesByIds,
    );
  }

  static FavoriteProvider get favoriteProvider {
    return FavoriteProvider(
      getFavorites: getFavorites,
      toggleFavorite: toggleFavorite,
      isFavorite: isFavorite,
      supabaseClient: supabaseClient,
    );
  }

  static ReviewRemoteDataSource get reviewRemoteDataSource =>
      ReviewRemoteDataSource(supabaseClient);

  static ReviewRepository get reviewRepository =>
      ReviewRepositoryImpl(reviewRemoteDataSource);

  static AddReview get addReview => AddReview(reviewRepository);
  static GetReviews get getReviews => GetReviews(reviewRepository);

  static ReviewProvider get reviewProvider => ReviewProvider(
      addReview: addReview,
      getReviews: getReviews,
      supabaseClient: supabaseClient
  );
}

