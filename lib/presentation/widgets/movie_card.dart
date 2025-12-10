import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/movie_entity.dart';
import '../pages/movie_detail_page.dart';
import '../providers/favorite_provider.dart';
import '../providers/rating_provider.dart';

class MovieListItem extends StatefulWidget {
  final MovieEntity movie;
  final VoidCallback? onTap;
  // Emits the new favorite value so parents can update state (e.g., Favorites page)
  final ValueChanged<bool>? onFavoriteChanged;

  const MovieListItem({
    super.key,
    required this.movie,
    this.onTap,
    this.onFavoriteChanged,
  });

  @override
  State<MovieListItem> createState() => _MovieListItemState();
}

class _MovieListItemState extends State<MovieListItem> {
  @override
  void initState() {
    super.initState();
    // Load user rating for this movie
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ratingProvider = Provider.of<RatingProvider>(
        context,
        listen: false,
      );
      ratingProvider.loadUserRating(widget.movie.id);
    });
  }

  void _toggleFavorite(FavoriteProvider favoriteProvider) async {
    await favoriteProvider.toggleFavorite(widget.movie.id);
    widget.onFavoriteChanged?.call(
      favoriteProvider.isFavorite(widget.movie.id),
    );
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
    return Consumer<FavoriteProvider>(
      builder: (context, favoriteProvider, child) {
        final isFavorite = favoriteProvider.isFavorite(widget.movie.id);

        return InkWell(
          onTap: _goDetail,
          child: Container(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Movie Poster with Watched Badge
                Consumer<RatingProvider>(
                  builder: (context, ratingProvider, child) {
                    final userRating = ratingProvider.getUserRatingForMovie(
                      widget.movie.id,
                    );
                    final isWatched = userRating?.isWatched ?? false;

                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(
                            widget.movie.posterPath,
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
                        // Watched Badge Overlay
                        if (isWatched && userRating != null)
                          Positioned(
                            top: 4,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.95),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.visibility,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        size: 12,
                                        color: Colors.amber,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        '${userRating.rating}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(width: 16),
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

                      if (widget.movie.ratingAverage != null)
                        Text(
                          'Rating: ${widget.movie.ratingAverage!.toStringAsFixed(1)}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        )
                      else if (widget.movie.releaseDate != null)
                        Text(
                          'Coming on: ${widget.movie.releaseDate}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: isFavorite
                      ? 'Remove from Favorites'
                      : 'Add to Favorites',
                  onPressed: () => _toggleFavorite(favoriteProvider),
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : null,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
