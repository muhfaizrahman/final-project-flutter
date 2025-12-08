import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/usecases/add_review.dart';
import '../../domain/usecases/get_reviews.dart';
import '../../domain/entities/review_entity.dart';

class ReviewProvider with ChangeNotifier {
  final AddReview _addReview;
  final GetReviews _getReviews;
  final SupabaseClient _supabase;

  List<ReviewEntity> _reviews = [];
  bool _isLoading = false;
  String? _error;

  ReviewProvider({
    required AddReview addReview,
    required GetReviews getReviews,
    required SupabaseClient supabaseClient,
  })  : _addReview = addReview,
        _getReviews = getReviews,
        _supabase = supabaseClient;

  List<ReviewEntity> get reviews => _reviews;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadReviews(int movieId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _reviews = await _getReviews(movieId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addReview(int movieId, int rating, String comment) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception("User not logged in");

    try {
      await _addReview(userId, movieId, rating, comment);
      await loadReviews(movieId);
    } catch (e) {
      rethrow;
    }
  }
}