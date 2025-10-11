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
      posterPath: 'assets/images/interstellar.jpg',
      ratingAverage: 8.1,
      genres: ['Sci-fi', 'Action'],
    ),
    Movie(
      id: 2,
      title: 'Movie 2',
      overview: "Overview for Movie 2",
      posterPath: "assets/images/shawshank.jpg",
      ratingAverage: 7.5,
      genres: ['Horror', 'Thriller'],
    ),
    Movie(
      id: 3,
      title: 'Movie 3',
      overview: "Overview for Movie 3",
      posterPath: "assets/images/dark_knight.jpg",
      ratingAverage: 8.0,
      genres: ['Action', 'Faction'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: dummyMovies.length,
        itemBuilder: (context, index) {
          final movie = dummyMovies[index];
          return MovieListItem(movie: movie);
        },
      ),
    );
  }
}
