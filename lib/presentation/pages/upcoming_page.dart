import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/movie_card.dart';
import '../providers/movie_provider.dart';

class UpcomingPage extends StatefulWidget {
  const UpcomingPage({super.key});

  @override
  State<UpcomingPage> createState() => _UpcomingPageState();
}

class _UpcomingPageState extends State<UpcomingPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final movieProvider = Provider.of<MovieProvider>(context, listen: false);
      if (movieProvider.upcomingMovies.isEmpty) {
        movieProvider.loadMoviesByCategory('upcoming');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieProvider>(
      builder: (context, movieProvider, child) {
        if (movieProvider.isLoading && movieProvider.upcomingMovies.isEmpty) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (movieProvider.error != null && movieProvider.upcomingMovies.isEmpty) {
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
                    onPressed: () => movieProvider.loadMoviesByCategory('upcoming'),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (movieProvider.upcomingMovies.isEmpty) {
          return const Scaffold(
            body: Center(
              child: Text('No movies available'),
            ),
          );
        }

        return Scaffold(
          body: ListView.builder(
            itemCount: movieProvider.upcomingMovies.length,
            itemBuilder: (context, index) {
              final movie = movieProvider.upcomingMovies[index];
              return MovieListItem(movie: movie);
            },
          ),
        );
      },
    );
  }
}
