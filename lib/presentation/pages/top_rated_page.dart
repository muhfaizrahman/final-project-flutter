import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/movie_card.dart';
import '../providers/movie_provider.dart';

class TopRatedPage extends StatefulWidget {
  const TopRatedPage({super.key});

  @override
  State<TopRatedPage> createState() => _TopRatedPageState();
}

class _TopRatedPageState extends State<TopRatedPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final movieProvider = Provider.of<MovieProvider>(context, listen: false);
      if (movieProvider.topRatedMovies.isEmpty) {
        movieProvider.loadMoviesByCategory('top_rated');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieProvider>(
      builder: (context, movieProvider, child) {
        if (movieProvider.isLoading && movieProvider.topRatedMovies.isEmpty) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (movieProvider.error != null && movieProvider.topRatedMovies.isEmpty) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${movieProvider.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => movieProvider.loadMoviesByCategory('top_rated'),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (movieProvider.topRatedMovies.isEmpty) {
          return const Scaffold(
            body: Center(
              child: Text('No movies available'),
            ),
          );
        }

        return Scaffold(
          body: ListView.builder(
            itemCount: movieProvider.topRatedMovies.length,
            itemBuilder: (context, index) {
              final movie = movieProvider.topRatedMovies[index];
              return MovieListItem(movie: movie);
            },
          ),
        );
      },
    );
  }
}
