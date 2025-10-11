import 'package:flutter/material.dart';

class TopRatedPage extends StatelessWidget {
  const TopRatedPage({super.key});

  final List<Map<String, dynamic>> movies = const [
    {
      'title': 'Interstellar',
      'rating': 8.6,
      'image': 'assets/images/interstellar.jpg',
      'description':
      'A team of explorers travels through a wormhole in space to ensure humanity\'s survival. Directed by Christopher Nolan.',
    },
    {
      'title': 'Inception',
      'rating': 8.8,
      'image': 'assets/images/inception.jpg',
      'description':
      'A thief enters the dreams of others to steal secrets and plant ideas, blurring the line between reality and illusion.',
    },
    {
      'title': 'The Dark Knight',
      'rating': 9.0,
      'image': 'assets/images/dark_knight.jpg',
      'description':
      'Batman faces chaos unleashed by the Joker in Gotham City, testing his morality and heroism to the limit.',
    },
    {
      'title': 'The Shawshank Redemption',
      'rating': 9.3,
      'image': 'assets/images/shawshank.jpg',
      'description':
      'Imprisoned banker Andy Dufresne finds hope and friendship in Shawshank Prison through perseverance and faith.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul Halaman
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Top Rated 🎬',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.6,
                ),
              ),
            ),

            // Daftar Film
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: ListView.builder(
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1C1C),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Poster
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              bottomLeft: Radius.circular(16),
                            ),
                            child: Image.asset(
                              movie['image'],
                              width: 120,
                              height: 180,
                              fit: BoxFit.cover,
                            ),
                          ),

                          // Detail Film
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    movie['title'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(Icons.star,
                                          color: Colors.amber, size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        movie['rating'].toString(),
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    movie['description'],
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                      height: 1.4,
                                    ),
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
