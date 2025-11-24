import '../../domain/entities/movie_entity.dart';

/// Data Model - Extends domain entity with data-specific functionality
/// This handles mapping from/to database/API responses
class MovieModel extends MovieEntity {
  const MovieModel({
    required super.id,
    required super.title,
    required super.overview,
    required super.posterPath,
    super.ratingAverage,
    super.releaseDate,
    super.genres,
  });

  /// Convert from JSON (database response)
  factory MovieModel.fromJson(Map<String, dynamic> json) {
    // Extract genres from nested structure
    List<String>? genres;
    if (json['movie_genres'] != null && json['movie_genres'] is List) {
      final genreList = json['movie_genres'] as List;
      genres = genreList
          .map((mg) => mg['genres']?['name'] as String?)
          .whereType<String>()
          .toList();
    }

    // Handle rating_average (can be double or null)
    double? ratingAverage;
    if (json['rating_average'] != null) {
      if (json['rating_average'] is num) {
        ratingAverage = (json['rating_average'] as num).toDouble();
      }
    }

    // Handle release_date (can be string or null)
    String? releaseDate;
    if (json['release_date'] != null) {
      releaseDate = json['release_date'].toString();
    }

    return MovieModel(
      id: json['id'] as int,
      title: json['title'] as String,
      overview: json['overview'] as String,
      posterPath: json['poster_path'] as String,
      ratingAverage: ratingAverage,
      releaseDate: releaseDate,
      genres: genres,
    );
  }

  /// Convert list of JSON to list of MovieModel
  static List<MovieModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => MovieModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Convert to JSON (for sending to database/API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'rating_average': ratingAverage,
      'release_date': releaseDate,
      'genres': genres,
    };
  }

  /// Convert to domain entity (explicit conversion, though MovieModel extends MovieEntity)
  MovieEntity toEntity() {
    return MovieEntity(
      id: id,
      title: title,
      overview: overview,
      posterPath: posterPath,
      ratingAverage: ratingAverage,
      releaseDate: releaseDate,
      genres: genres,
    );
  }
}

