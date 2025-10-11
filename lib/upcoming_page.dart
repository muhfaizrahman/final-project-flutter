import 'package:final_project/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'movie_model.dart';

class UpcomingPage extends StatelessWidget {
  const UpcomingPage({super.key});

  final List<Movie> dummyMovies = const [
    Movie(
      id: 1,
      title: 'Inside Out 2',
      overview: 'Petualangan baru di dalam pikiran Riley.',
      posterPath: 'assets/images/placeholder.webp',
      releaseDate: '2025-12-20',
      genres: ['Animation', 'Comedy'],
    ),
    Movie(
      id: 2,
      title: 'The Future Wars',
      overview: 'Epic sci-fi movie set in 2077.',
      posterPath: 'assets/images/placeholder.webp',
      releaseDate: '2025-11-10',
      genres: ['Action', 'Sci-Fi'],
    ),
    Movie(
      id: 3,
      title: 'Dream Catchers',
      overview: 'A heartfelt drama about chasing dreams.',
      posterPath: 'assets/images/placeholder.webp',
      releaseDate: '2025-10-30',
      genres: ['Drama', 'Romance'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upcoming Movies"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: dummyMovies.length,
        itemBuilder: (context, index) {
          final movie = dummyMovies[index];
          return _MovieListItem(movie: movie);
        },
      ),
    );
  }
}

class _MovieListItem extends StatelessWidget {
  final Movie movie;
  const _MovieListItem({required this.movie});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailPage(movie: movie),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                movie.posterPath,
                width: 100,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox(
                    width: 100,
                    height: 150,
                    child: Icon(Icons.error),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  if (movie.releaseDate != null)
                    Text(
                      'Coming on: ${movie.releaseDate}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),

                  if (movie.genres != null && movie.genres!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        'Genre: ${movie.genres!.join(', ')}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
