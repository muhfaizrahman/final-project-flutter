import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/movie_card.dart';
import '../presentation/providers/movie_provider.dart';

class NowShowingPage extends StatefulWidget {
  const NowShowingPage({super.key});

  @override
  State<NowShowingPage> createState() => _NowShowingPageState();
}

class _NowShowingPageState extends State<NowShowingPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final movieProvider = Provider.of<MovieProvider>(context, listen: false);
      if (movieProvider.nowShowingMovies.isEmpty) {
        movieProvider.loadMoviesByCategory('now_showing');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieProvider>(
      builder: (context, movieProvider, child) {
        if (movieProvider.isLoading && movieProvider.nowShowingMovies.isEmpty) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (movieProvider.error != null && movieProvider.nowShowingMovies.isEmpty) {
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
                    onPressed: () => movieProvider.loadMoviesByCategory('now_showing'),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (movieProvider.nowShowingMovies.isEmpty) {
          return const Scaffold(
            body: Center(
              child: Text('No movies available'),
            ),
          );
        }

        return Scaffold(
          body: ListView.builder(
            itemCount: movieProvider.nowShowingMovies.length,
            itemBuilder: (context, index) {
              final movie = movieProvider.nowShowingMovies[index];
              return MovieListItem(movie: movie);
            },
          ),
        );
      },
    );
  }
}
