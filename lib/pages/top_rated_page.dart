import 'package:final_project/models/movie.dart';
import 'package:final_project/widgets/movie_card.dart';
import 'package:flutter/material.dart';

class TopRatedPage extends StatelessWidget {
  const TopRatedPage({super.key});

  final List<Movie> dummyTopRatedMovies = const [
    Movie(
      id: 1,
      title: 'Interstellar',
      overview: 'A team of explorers travels through a wormhole in space to ensure humanity\'s survival. Directed by Christopher Nolan.',
      posterPath: 'assets/images/interstellar.jpg',
      ratingAverage: 8.5,
    ),
    Movie(
      id: 2,
      title: 'Inception',
      overview: 'A thief enters the dreams of others to steal secrets and plant ideas, blurring the line between reality and illusion.',
      posterPath: 'assets/images/inception.jpg',
      ratingAverage: 7.5,
    ),
    Movie(
      id: 3,
      title: 'The Dark Knight',
      overview: 'Batman faces chaos unleashed by the Joker in Gotham City, testing his morality and heroism to the limit.',
      posterPath: 'assets/images/dark_knight.jpg',
      ratingAverage: 8.8,
    ),
    Movie(
      id: 4,
      title: 'The Shawshank Redemption',
      overview: 'Imprisoned banker Andy Dufresne finds hope and friendship in Shawshank Prison through perseverance and faith.',
      posterPath: 'assets/images/shawshank.jpg',
      ratingAverage: 9.3,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: dummyTopRatedMovies.length,
        itemBuilder: (context, index) {
          final movie = dummyTopRatedMovies[index];
          return MovieListItem(movie: movie);
        },
      ),
    );
  }
}
