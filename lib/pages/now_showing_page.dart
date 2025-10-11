import 'package:flutter/material.dart';
import '../widgets/movie_card.dart';
import '../models/movie.dart';

class NowShowingPage extends StatelessWidget {
  const NowShowingPage({super.key});

  final List<Movie> dummyMovies = const [
    Movie(
      id: 1,
      title: 'Movie 1',
      overview: 'Overview for Movie 1',
      posterPath: 'assets/images/placeholder.webp',
      ratingAverage: 8.1,
    ),
    Movie(
      id: 2,
      title: 'Movie 2',
      overview: "Overview for Movie 2",
      posterPath: "assets/images/placeholder.webp",
      ratingAverage: 7.5,
    ),
    Movie(
      id: 3,
      title: 'Movie 3',
      overview: "Overview for Movie 3",
      posterPath: "assets/images/placeholder.webp",
      ratingAverage: 8.0
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: dummyMovies.length,
        itemBuilder: (context, index){
          final movie = dummyMovies[index];
          return MovieListItem(movie: movie);
        },
      ),
    );
  }
}