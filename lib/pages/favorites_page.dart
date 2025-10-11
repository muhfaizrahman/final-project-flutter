import 'package:flutter/material.dart';
import 'package:final_project/models/movie.dart';
import '../widgets/movie_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  final List<Movie> dummyFavoriteMovies = const [
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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: dummyFavoriteMovies.length,
        itemBuilder: (context, index){
          final movie = dummyFavoriteMovies[index];
          return MovieListItem(movie: movie);
        },
      ),
    );
  }
}