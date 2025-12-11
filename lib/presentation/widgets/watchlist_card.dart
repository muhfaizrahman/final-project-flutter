import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/movie_entity.dart';
import '../pages/movie_detail_page.dart';
import '../providers/watchlist_provider.dart';

class WatchlistListItem extends StatefulWidget {
  final MovieEntity movie;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onWatchlistChanged;

  const WatchlistListItem({
    super.key,
    required this.movie,
    this.onTap,
    this.onWatchlistChanged,
  });

  @override
  State<WatchlistListItem> createState() => _WatchlistListItemState();
}

class _WatchlistListItemState extends State<WatchlistListItem> {
  bool isLoading = true;
  bool isInWatchlist = false;

  @override
  void initState() {
    super.initState();
    // Gunakan Future.microtask untuk memanggil async di initState,
    // meski _loadStatus() tidak memanggil notifyListeners, ini kebiasaan yang baik.
    Future.microtask(() => _loadStatus());
  }

  Future<void> _loadStatus() async {
    final provider = Provider.of<WatchlistProvider>(context, listen: false);

    // FIX 1: Mengganti 'check' menjadi 'isMovieInWatchlist'
    final result = await provider.isMovieInWatchlist(widget.movie.id);

    // Pastikan widget masih mounted sebelum memanggil setState
    if (mounted) {
      setState(() {
        isInWatchlist = result;
        isLoading = false;
      });
    }
  }

  Future<void> _toggleWatchlist() async {
    final provider = Provider.of<WatchlistProvider>(context, listen: false);

    // FIX 2: toggleWatchlistUC tidak ada di Provider. Panggil toggleWatchlistStatus
    // Asumsi: Anda ingin menggunakan fungsi yang sudah Anda buat di Provider
    await provider.toggleWatchlistStatus(widget.movie.id);

    // Setelah toggle, status di WatchlistProvider sudah terupdate (karena loadWatchlist() dipanggil di dalamnya)
    // Ambil status terbaru untuk update UI lokal
    final updated = await provider.isMovieInWatchlist(widget.movie.id);

    if (mounted) {
      setState(() {
        isInWatchlist = updated;
      });
    }

    widget.onWatchlistChanged?.call(updated);
  }

  void _goDetail() {
    if (widget.onTap != null) {
      widget.onTap!.call();
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailPage(movie: widget.movie),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _goDetail,
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster + Badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    widget.movie.posterPath,
                    width: 100,
                    height: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (context, _, __) => const SizedBox(
                      width: 100,
                      height: 150,
                      child: Icon(Icons.error),
                    ),
                  ),
                ),

                if (isInWatchlist)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.bookmark, size: 12, color: Colors.white),
                          SizedBox(width: 3),
                          Text(
                            'Watchlist',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 16),

            // Movie Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.movie.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  if (widget.movie.genres != null &&
                      widget.movie.genres!.isNotEmpty)
                    Text(
                      widget.movie.genres!.join(', '),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.blueGrey,
                      ),
                    ),

                  const SizedBox(height: 8),

                  if (widget.movie.releaseDate != null)
                    Text(
                      'Release: ${widget.movie.releaseDate}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ),

            // Watchlist Button
            IconButton(
              tooltip:
              isInWatchlist ? 'Remove from Watchlist' : 'Add to Watchlist',
              onPressed: isLoading ? null : _toggleWatchlist,
              icon: Icon(
                isInWatchlist ? Icons.bookmark : Icons.bookmark_border,
                color: isInWatchlist ? Colors.amber : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}