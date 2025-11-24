import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/datasources/movie_remote_datasource.dart';
import '../../data/repositories/movie_repository.dart';
import '../../models/movie.dart';

class MovieProvider with ChangeNotifier {
  final MovieRepository _repository;
  
  List<Movie> _nowShowingMovies = [];
  List<Movie> _upcomingMovies = [];
  List<Movie> _topRatedMovies = [];
  List<Movie> _allMovies = [];
  
  bool _isLoading = false;
  String? _error;

  MovieProvider()
      : _repository = MovieRepository(
          MovieRemoteDataSource(Supabase.instance.client),
        );

  List<Movie> get nowShowingMovies => _nowShowingMovies;
  List<Movie> get upcomingMovies => _upcomingMovies;
  List<Movie> get topRatedMovies => _topRatedMovies;
  List<Movie> get allMovies => _allMovies;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load all movies
  Future<void> loadAllMovies() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allMovies = await _repository.getAllMovies();
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
      final movies = await _repository.getMoviesByCategory(category);
      
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
  Future<Movie?> getMovieById(int id) async {
    try {
      return await _repository.getMovieById(id);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// Get movies by IDs
  Future<List<Movie>> getMoviesByIds(List<int> ids) async {
    try {
      return await _repository.getMoviesByIds(ids);
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

