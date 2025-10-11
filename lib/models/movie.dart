import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../pages/movie_detail_page.dart';

class Movie extends Equatable {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final double ratingAverage;

  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.ratingAverage,
  });

  @override
  List<Object?> get props => [id, title, overview, posterPath, ratingAverage];
}