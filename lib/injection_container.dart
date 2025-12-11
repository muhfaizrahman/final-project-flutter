import 'package:supabase_flutter/supabase_flutter.dart';

// MOVIE
import 'data/datasources/movie_remote_datasource.dart';
import 'data/repositories/movie_repository.dart';
import 'domain/usecases/get_all_movies.dart';
import 'domain/usecases/get_movies_by_category.dart';
import 'domain/usecases/get_movie_by_id.dart';
import 'domain/usecases/get_movies_by_ids.dart';
import 'presentation/providers/movie_provider.dart';

// FAVORITE
import 'data/datasources/favorite_remote_datasource.dart';
import 'data/repositories/favorite_repository.dart';
import 'domain/usecases/get_favorites.dart';
import 'domain/usecases/toggle_favorite.dart';
import 'domain/usecases/is_favorite.dart';
import 'presentation/providers/favorite_provider.dart';

// REVIEW
import 'data/datasources/review_remote_datasource.dart';
import 'data/repositories/review_repository_impl.dart';
import 'domain/repositories/review_repository.dart';
import 'domain/usecases/add_review.dart';
import 'domain/usecases/get_reviews.dart';
import 'presentation/providers/review_provider.dart';

// RATING
import 'data/datasources/rating_remote_datasource.dart';
import 'data/repositories/rating_repository_impl.dart';
import 'domain/usecases/add_rating.dart';
import 'domain/usecases/update_rating.dart';
import 'domain/usecases/delete_rating.dart';
import 'domain/usecases/get_user_rating.dart';
import 'domain/usecases/get_movie_ratings.dart';
import 'presentation/providers/rating_provider.dart';

// =====================================================
// 👇 WATCHLIST (BARU)
// =====================================================
import 'data/datasources/watchlist_remote_datasource.dart';
import 'data/repositories/watchlist_repository_impl.dart';
import 'domain/repositories/watchlist_repository.dart';
import 'domain/usecases/get_watchlist.dart';
import 'domain/usecases/is_in_watchlist.dart';
import 'domain/usecases/toggle_watchlist.dart';
import 'presentation/providers/watchlist_provider.dart';
// =====================================================


class InjectionContainer {
  static SupabaseClient get supabaseClient => Supabase.instance.client;

  // =====================================================
  // MOVIE
  // =====================================================

  static MovieRemoteDataSource get movieRemoteDataSource =>
      MovieRemoteDataSource(supabaseClient);

  static MovieRepository get movieRepository =>
      MovieRepository(movieRemoteDataSource);

  static GetAllMovies get getAllMovies => GetAllMovies(movieRepository);
  static GetMoviesByCategory get getMoviesByCategory =>
      GetMoviesByCategory(movieRepository);
  static GetMovieById get getMovieById => GetMovieById(movieRepository);
  static GetMoviesByIds get getMoviesByIds =>
      GetMoviesByIds(movieRepository);

  static MovieProvider get movieProvider => MovieProvider(
    getAllMovies: getAllMovies,
    getMoviesByCategory: getMoviesByCategory,
    getMovieById: getMovieById,
    getMoviesByIds: getMoviesByIds,
  );

  // =====================================================
  // FAVORITE
  // =====================================================

  static FavoriteRemoteDataSource get favoriteRemoteDataSource =>
      FavoriteRemoteDataSource(supabaseClient);

  static FavoriteRepository get favoriteRepository =>
      FavoriteRepository(favoriteRemoteDataSource);

  static GetFavorites get getFavorites => GetFavorites(
    favoriteRepository,
        () => supabaseClient.auth.currentUser?.id ?? '',
  );

  static ToggleFavorite get toggleFavorite => ToggleFavorite(
    favoriteRepository,
        () => supabaseClient.auth.currentUser?.id ?? '',
  );

  static IsFavorite get isFavorite => IsFavorite(
    favoriteRepository,
        () => supabaseClient.auth.currentUser?.id ?? '',
  );

  static FavoriteProvider get favoriteProvider => FavoriteProvider(
    getFavorites: getFavorites,
    toggleFavorite: toggleFavorite,
    isFavorite: isFavorite,
    supabaseClient: supabaseClient,
  );

  // =====================================================
  // REVIEW
  // =====================================================

  static ReviewRemoteDataSource get reviewRemoteDataSource =>
      ReviewRemoteDataSource(supabaseClient);

  static ReviewRepository get reviewRepository =>
      ReviewRepositoryImpl(reviewRemoteDataSource);

  static AddReview get addReview => AddReview(reviewRepository);
  static GetReviews get getReviews => GetReviews(reviewRepository);

  static ReviewProvider get reviewProvider => ReviewProvider(
    addReview: addReview,
    getReviews: getReviews,
    supabaseClient: supabaseClient,
  );

  // =====================================================
  // RATING
  // =====================================================

  static RatingRemoteDataSource get ratingRemoteDataSource =>
      RatingRemoteDataSource(supabaseClient);

  static RatingRepositoryImpl get ratingRepository =>
      RatingRepositoryImpl(ratingRemoteDataSource);

  static AddRating get addRating => AddRating(ratingRepository);
  static UpdateRating get updateRating => UpdateRating(ratingRepository);
  static DeleteRating get deleteRating => DeleteRating(ratingRepository);
  static GetUserRating get getUserRating => GetUserRating(ratingRepository);
  static GetMovieRatings get getMovieRatings =>
      GetMovieRatings(ratingRepository);

  static RatingProvider get ratingProvider => RatingProvider(
    addRating: addRating,
    updateRating: updateRating,
    deleteRating: deleteRating,
    getUserRating: getUserRating,
    getMovieRatings: getMovieRatings,
    supabaseClient: supabaseClient,
  );

  // =====================================================
  // 👇 WATCHLIST (PENAMBAHAN BARU)
  // =====================================================

  // Asumsi: WatchlistRemoteDataSource, WatchlistRepositoryImpl, dan WatchlistRepository
  // ada di jalur yang sama dengan entitas Anda yang lain.

  static WatchlistRemoteDataSource get watchlistRemoteDataSource =>
      WatchlistRemoteDataSource(supabaseClient);

  static WatchlistRepository get watchlistRepository =>
      WatchlistRepositoryImpl(watchlistRemoteDataSource);

  static GetWatchlist get getWatchlist => GetWatchlist(
    watchlistRepository,
        () => supabaseClient.auth.currentUser?.id ?? '',
  );

  static ToggleWatchlist get toggleWatchlist => ToggleWatchlist(
    watchlistRepository,
        () => supabaseClient.auth.currentUser?.id ?? '',
  );

  static IsInWatchlist get isInWatchlist => IsInWatchlist(
    watchlistRepository,
        () => supabaseClient.auth.currentUser?.id ?? '',
  );

  static WatchlistProvider get watchlistProvider => WatchlistProvider(
    getWatchlistUC: getWatchlist,
    isInWatchlistUC: isInWatchlist,
    toggleWatchlistUC: toggleWatchlist,
    supabaseClient: supabaseClient,
  );
// =====================================================
}