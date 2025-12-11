import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/movie_entity.dart';
import '../providers/favorite_provider.dart';
import '../providers/review_provider.dart';
import '../providers/rating_provider.dart';
import '../providers/watchlist_provider.dart';
import '../widgets/rating_input_widget.dart';

class MovieDetailPage extends StatefulWidget {
  final MovieEntity movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReviewProvider>(
        context,
        listen: false,
      ).loadReviews(widget.movie.id);
      final ratingProvider = Provider.of<RatingProvider>(
        context,
        listen: false,
      );
      ratingProvider.loadUserRating(widget.movie.id);
      ratingProvider.loadMovieRatings(widget.movie.id);

      Provider.of<WatchlistProvider>(
        context,
        listen: false,
      ).isMovieInWatchlist(widget.movie.id);
    });
  }

  bool _isUpcomingMovie(MovieEntity movie) {
    if (movie.releaseDate == null || movie.releaseDate!.isEmpty) {
      return false;
    }

    try {
      final releaseDate = DateTime.parse(movie.releaseDate!);
      final now = DateTime.now();
      return releaseDate.isAfter(now);
    } catch (e) {
      return false;
    }
  }

  void _showAddReviewDialog(BuildContext context) {
    final ratingProvider = Provider.of<RatingProvider>(context, listen: false);
    final userRating = ratingProvider.getUserRatingForMovie(widget.movie.id);

    if (userRating == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please rate this movie first before adding a review!"),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    final commentCtrl = TextEditingController();
    final selectedRating = userRating.rating;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Write a Review'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Your rating: $selectedRating/10',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: commentCtrl,
                decoration: const InputDecoration(
                  hintText: "Share your thoughts about this movie...",
                  border: OutlineInputBorder(),
                  labelText: 'Your Review',
                ),
                maxLines: 5,
                autofocus: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (commentCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please write a comment!"),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }

                final provider = Provider.of<ReviewProvider>(
                  context,
                  listen: false,
                );
                try {
                  await provider.addReview(
                    widget.movie.id,
                    selectedRating,
                    commentCtrl.text.trim(),
                  );
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Review posted successfully!"),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Failed: $e"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text('Post Review'),
            ),
          ],
        );
      },
    );
  }

  void _showRatingDialog(BuildContext context) {
    final ratingProvider = Provider.of<RatingProvider>(context, listen: false);
    final currentRating = ratingProvider
        .getUserRatingForMovie(widget.movie.id)
        ?.rating;
    int? selectedRating = currentRating;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            currentRating == null ? 'Rate this Movie' : 'Update Your Rating',
          ),
          content: RatingInputWidget(
            initialRating: currentRating,
            onRatingSelected: (rating) {
              selectedRating = rating;
            },
          ),
          actions: [
            if (currentRating != null)
              TextButton(
                onPressed: () async {
                  try {
                    await ratingProvider.removeRating(widget.movie.id);
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Rating removed!")),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Error: $e"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: const Text(
                  'Remove',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (selectedRating == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please select a rating"),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }
                try {
                  await ratingProvider.submitRating(
                    widget.movie.id,
                    selectedRating!,
                  );
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          currentRating == null
                              ? "Rating submitted!"
                              : "Rating updated!",
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error: $e"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
        actions: [

          Consumer<WatchlistProvider>(
            builder: (context, watchlistProvider, child) {
              return FutureBuilder<bool>(
                future: watchlistProvider.isMovieInWatchlist(widget.movie.id),
                builder: (context, snapshot) {

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child: Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    );
                  }

                  final bool isWatching = snapshot.data ?? false;

                  return IconButton(
                    icon: Icon(
                      isWatching ? Icons.bookmark : Icons.bookmark_border,
                      color: isWatching ? Colors.blueAccent : null,
                    ),
                    onPressed: () async {
                      await watchlistProvider.toggleWatchlistStatus(widget.movie.id);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isWatching
                                  ? 'Removed from Watchlist'
                                  : 'Added to Watchlist',
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      }
                    },
                    tooltip: isWatching
                        ? 'Remove from Watchlist'
                        : 'Add to Watchlist',
                  );
                },
              );
            },
          ),


          Consumer<FavoriteProvider>(
            builder: (context, favoriteProvider, child) {
              final isFavorite = favoriteProvider.isFavorite(widget.movie.id);

              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
                onPressed: () async {
                  await favoriteProvider.toggleFavorite(widget.movie.id);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isFavorite
                              ? 'Removed from favorites'
                              : 'Added to favorites',
                        ),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  }
                },
                tooltip: isFavorite
                    ? 'Remove from Favorites'
                    : 'Add to Favorites',
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.asset(
                    widget.movie.posterPath,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              if (widget.movie.ratingAverage != null)
                Text(
                  'Rating: ${widget.movie.ratingAverage} / 10',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
              if (widget.movie.ratingAverage != null)
                const SizedBox(height: 16),

              if (widget.movie.genres != null &&
                  widget.movie.genres!.isNotEmpty) ...[
                Text(
                  'Genres: ${widget.movie.genres!.join(', ')}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blueGrey,
                  ),
                ),
                const SizedBox(height: 16),
              ],

              if (widget.movie.releaseDate != null) ...[
                Text(
                  'Release Date: ${widget.movie.releaseDate}',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 16),
              ],

              const Text(
                'Overview',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              Text(
                widget.movie.overview,
                style: const TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),

              const SizedBox(height: 32),
              const Divider(),

              // ========== RATING SECTION ==========
              // Only show for released movies (hide for upcoming)
              if (!_isUpcomingMovie(widget.movie))
                Consumer<RatingProvider>(
                  builder: (context, ratingProvider, child) {
                    final userRating = ratingProvider.getUserRatingForMovie(
                      widget.movie.id,
                    );
                    final avgRating = ratingProvider.averageRating;
                    final totalRatings = ratingProvider.movieRatings.length;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Your Rating',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (avgRating != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${avgRating.toStringAsFixed(1)}/10',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      ' ($totalRatings)',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        if (userRating != null)
                          Card(
                            color: Colors.blue.shade50,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.amber,
                                child: Text(
                                  userRating.rating.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Row(
                                children: [
                                  Text(
                                    'You rated: ${userRating.rating}/10',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  if (userRating.isWatched)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade100,
                                        borderRadius: BorderRadius.circular(
                                          12,
                                        ),
                                        border: Border.all(
                                          color: Colors.green.shade300,
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.visibility,
                                            size: 14,
                                            color: Colors.green.shade700,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Watched',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.green.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                              subtitle: Text(
                                'Rated on ${userRating.createdAt.day}/${userRating.createdAt.month}/${userRating.createdAt.year}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _showRatingDialog(context),
                                tooltip: 'Update rating',
                              ),
                            ),
                          )
                        else
                          Center(
                            child: ElevatedButton.icon(
                              onPressed: () => _showRatingDialog(context),
                              icon: const Icon(Icons.star_rate),
                              label: const Text('Rate this Movie'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),

              const SizedBox(height: 32),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'User Reviews',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => _showAddReviewDialog(context),
                    icon: const Icon(Icons.add_comment),
                    label: const Text("Add Review"),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Consumer<ReviewProvider>(
                builder: (context, reviewProvider, child) {
                  if (reviewProvider.isLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (reviewProvider.error != null) {
                    return Text(
                      "Error: ${reviewProvider.error}",
                      style: const TextStyle(color: Colors.red),
                    );
                  }

                  if (reviewProvider.reviews.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text(
                          "Belum ada review. Jadilah yang pertama!",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: reviewProvider.reviews.length,
                    separatorBuilder: (ctx, i) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final review = reviewProvider.reviews[index];
                      return Card(
                        elevation: 2,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.white,
                            child: Text(review.rating.toString()),
                          ),
                          title: Text(
                            "User ${review.userId.substring(0, 4)}...",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(review.comment),
                          ),
                          trailing: Text(
                            "${review.createdAt.day}/${review.createdAt.month}/${review.createdAt.year}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}