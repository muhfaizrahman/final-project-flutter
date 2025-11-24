import 'package:flutter/foundation.dart';
import '../../domain/entities/movie_entity.dart';
import '../../domain/usecases/get_all_movies.dart';
import '../../domain/usecases/get_movies_by_category.dart';
import '../../domain/usecases/get_movie_by_id.dart';
import '../../domain/usecases/get_movies_by_ids.dart';

/// Presentation Layer Provider for Movies
/// Uses Use Cases from Domain Layer
class MovieProvider with ChangeNotifier {
  final GetAllMovies _getAllMovies;
  final GetMoviesByCategory _getMoviesByCategory;
  final GetMovieById _getMovieById;
  final GetMoviesByIds _getMoviesByIds;
  
  List<MovieEntity> _nowShowingMovies = [];
  List<MovieEntity> _upcomingMovies = [];
  List<MovieEntity> _topRatedMovies = [];
  List<MovieEntity> _allMovies = [];
  
  bool _isLoading = false;
  String? _error;

  MovieProvider({
    required GetAllMovies getAllMovies,
    required GetMoviesByCategory getMoviesByCategory,
    required GetMovieById getMovieById,
    required GetMoviesByIds getMoviesByIds,
  })  : _getAllMovies = getAllMovies,
        _getMoviesByCategory = getMoviesByCategory,
        _getMovieById = getMovieById,
        _getMoviesByIds = getMoviesByIds;

  List<MovieEntity> get nowShowingMovies => _nowShowingMovies;
  List<MovieEntity> get upcomingMovies => _upcomingMovies;
  List<MovieEntity> get topRatedMovies => _topRatedMovies;
  List<MovieEntity> get allMovies => _allMovies;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load all movies
  Future<void> loadAllMovies() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allMovies = await _getAllMovies();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _allMovies = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load movies by category
  Future<void> loadMoviesByCategory(String category) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final movies = await _getMoviesByCategory(category);
      
      switch (category) {
        case 'now_showing':
          _nowShowingMovies = movies;
          break;
        case 'upcoming':
          _upcomingMovies = movies;
          break;
        case 'top_rated':
          _topRatedMovies = movies;
          break;
      }
      
      _error = null;
    } catch (e) {
      _error = e.toString();
      switch (category) {
        case 'now_showing':
          _nowShowingMovies = [];
          break;
        case 'upcoming':
          _upcomingMovies = [];
          break;
        case 'top_rated':
          _topRatedMovies = [];
          break;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load all categories
  Future<void> loadAllCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.wait([
        loadMoviesByCategory('now_showing'),
        loadMoviesByCategory('upcoming'),
        loadMoviesByCategory('top_rated'),
      ]);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get movie by ID
  Future<MovieEntity?> getMovieById(int id) async {
    try {
      return await _getMovieById(id);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// Get movies by IDs
  Future<List<MovieEntity>> getMoviesByIds(List<int> ids) async {
    try {
      return await _getMoviesByIds(ids);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return [];
    }
  }

  /// Initialize - load all categories
  void initialize() {
    loadAllCategories();
  }

  /// Clear all data
  void clear() {
    _nowShowingMovies = [];
    _upcomingMovies = [];
    _topRatedMovies = [];
    _allMovies = [];
    _error = null;
    notifyListeners();
  }
}
