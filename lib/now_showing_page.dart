import 'package:final_project/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'movie_model.dart';

class NowShowingPage extends StatelessWidget {
  const NowShowingPage({super.key});

  final List<Movie> dummyMovies = const [
    Movie(
      id: 1,
      title: 'Movie 1',
      overview: 'Overview for Movie 1',
      posterPath: 'assets/images/placeholder.webp',
      ratingAverage: 8.1,
      genres: ['Action', 'Adventure'],
    ),
    Movie(
      id: 2,
      title: 'Movie 2',
      overview: "Overview for Movie 2",
      posterPath: "assets/images/placeholder.webp",
      ratingAverage: 7.5,
      genres: ['Drama'],
    ),
    Movie(
      id: 3,
      title: 'Movie 3',
      overview: "Overview for Movie 3",
      posterPath: "assets/images/placeholder.webp",
      ratingAverage: 8.0,
      genres: ['Sci-Fi', 'Thriller'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Now Showing"),
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
                  Text(
                    'Rating: ${movie.ratingAverage}',
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
