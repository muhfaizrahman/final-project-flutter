import 'package:flutter/foundation.dart';

@immutable
class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final double? ratingAverage;
  final String? releaseDate;
  final List<String>? genres;
  final bool isFavorite;

  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    this.ratingAverage,
    this.releaseDate,
    this.genres,
    this.isFavorite = false,
  });

  Movie copyWith({
    int? id,
    String? title,
    String? overview,
    String? posterPath,
    double? ratingAverage,
    String? releaseDate,
    List<String>? genres,
    bool? isFavorite,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      overview: overview ?? this.overview,
      posterPath: posterPath ?? this.posterPath,
      ratingAverage: ratingAverage ?? this.ratingAverage,
      releaseDate: releaseDate ?? this.releaseDate,
      genres: genres ?? this.genres,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
