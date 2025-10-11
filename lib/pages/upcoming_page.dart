import 'package:flutter/material.dart';
import '../widgets/movie_card.dart';
import '../models/movie.dart';

class UpcomingPage extends StatelessWidget {
  const UpcomingPage({super.key});

  final List<Movie> dummyMovies = const [
    Movie(
      id: 1,
      title: 'Inception',
      overview: 'Overview Inception.',
      posterPath: 'assets/images/inception.jpg',
      releaseDate: '2025-12-20',
      genres: ['Animation', 'Comedy', 'Family'],
    ),
    Movie(
      id: 2,
      title: 'Interstellar',
      overview: 'Overview Interstellar.',
      posterPath: 'assets/images/interstellar.jpg',
      releaseDate: '2025-11-15',
      genres: ['Action', 'Sci-Fi', 'Adventure'],
    ),
    Movie(
      id: 3,
      title: 'Shawhan Redemption',
      overview: 'Overview Shawhan Redemption.',
      posterPath: 'assets/images/shawshank.jpg',
      releaseDate: '2025-10-25',
      genres: ['Drama', 'Romance'],
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
