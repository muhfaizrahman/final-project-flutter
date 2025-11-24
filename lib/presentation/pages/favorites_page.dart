import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/movie_card.dart';
import '../providers/favorite_provider.dart';
import '../providers/movie_provider.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final favoriteProvider = Provider.of<FavoriteProvider>(context, listen: false);
      final movieProvider = Provider.of<MovieProvider>(context, listen: false);
      
      // Load favorites and ensure all movies are loaded
      favoriteProvider.loadFavorites();
      if (movieProvider.allMovies.isEmpty) {
        movieProvider.loadAllMovies();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<FavoriteProvider, MovieProvider>(
      builder: (context, favoriteProvider, movieProvider, child) {
        // Compute favorite movies from provider state
        final favoriteIds = favoriteProvider.favoriteMovieIds.toList();
        final favoriteMovies = movieProvider.allMovies
            .where((movie) => favoriteIds.contains(movie.id))
            .toList();

        if (favoriteProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (favoriteProvider.error != null) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${favoriteProvider.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => favoriteProvider.loadFavorites(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (favoriteMovies.isEmpty) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No favorite movies yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the heart icon on any movie to add it to favorites',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          body: ListView.builder(
            itemCount: favoriteMovies.length,
            itemBuilder: (context, index) {
              final movie = favoriteMovies[index];
              return MovieListItem(
                movie: movie,
              );
            },
          ),
        );
      },
    );
  }
}