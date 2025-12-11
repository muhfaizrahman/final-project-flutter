import 'package:final_project/domain/entities/watchlist_item.dart';

class WatchlistModel {
  final int id;
  final String userId;
  final int movieId;
  final String title;
  final String poster;
  final String category;

  WatchlistModel({
    required this.id,
    required this.userId,
    required this.movieId,
    required this.title,
    required this.poster,
    required this.category,
  });

  factory WatchlistModel.fromMap(Map<String, dynamic> map) {
    return WatchlistModel(
      id: map['id'],
      userId: map['user_id'],
      movieId: map['movie_id'],
      title: map['title'],
      poster: map['poster'],
      category: map['category'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'movie_id': movieId,
      'title': title,
      'poster': poster,
      'category': category,
    };
  }

  WatchlistItem toEntity() {
    return WatchlistItem(
      id: id,
      userId: userId,
      movieId: movieId,
      title: title,
      poster: poster,
      category: category,
    );
  }
}
