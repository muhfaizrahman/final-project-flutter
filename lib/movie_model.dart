import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final double? ratingAverage;
  final String? releaseDate;
  final List<String> genres;

  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    this.ratingAverage,
    this.releaseDate,
    required this.genres,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    overview,
    posterPath,
    ratingAverage,
    releaseDate,
    genres,
  ];
}
