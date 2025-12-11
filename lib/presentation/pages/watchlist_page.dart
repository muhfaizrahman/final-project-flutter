import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/watchlist_provider.dart';
import '../providers/movie_provider.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<WatchlistProvider>(context, listen: false).loadWatchlist();
    });
  }

  @override
  Widget build(BuildContext context) {
    final watchlistProvider = Provider.of<WatchlistProvider>(context);
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);
    final watchlistIds = watchlistProvider.watchlist;

    if (watchlistProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (watchlistIds.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmark_border, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Watchlist Anda masih kosong.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            Text(
              'Tambahkan film dari halaman film lainnya.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        itemCount: watchlistIds.length,
        itemBuilder: (context, index) {
          final movieId = watchlistIds[index];

          return FutureBuilder(
            future: movieProvider.getMovieById(movieId),
            builder: (context, snapshot) {

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                );
              }

              if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
                return ListTile(
                  title: Text('Film ID $movieId tidak dapat dimuat.'),
                  subtitle: const Text('Kesalahan data atau film sudah dihapus.'),
                  leading: const Icon(Icons.error, color: Colors.red),
                );
              }

              final movie = snapshot.data!;

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[200]!),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        movie.posterPath,
                        width: 80,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(width: 80, height: 120, color: Colors.grey, child: const Icon(Icons.broken_image, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.title,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            movie.category ?? 'Kategori Tidak Tersedia',
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                'Rating: ${movie.ratingAverage?.toStringAsFixed(1) ?? 'N/A'}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.bookmark, color: Colors.blueAccent),
                      onPressed: () async {
                        final provider = Provider.of<WatchlistProvider>(context, listen: false);
                        await provider.removeWatchlist(movie.id);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${movie.title} dihapus dari Watchlist.')),
                          );
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}