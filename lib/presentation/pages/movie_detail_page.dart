import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/movie_entity.dart';
import '../providers/favorite_provider.dart';
import '../providers/review_provider.dart';

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
      Provider.of<ReviewProvider>(context, listen: false)
          .loadReviews(widget.movie.id);
    });
  }

  void _showAddReviewDialog(BuildContext context) {
    final commentCtrl = TextEditingController();
    int selectedRating = 8; // Default rating

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tulis Review'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Berapa rating film ini?"),
              StatefulBuilder(
                builder: (context, setState) {
                  return DropdownButton<int>(
                    value: selectedRating,
                    items: List.generate(10, (index) => index + 1)
                        .map((val) => DropdownMenuItem(
                      value: val,
                      child: Text("$val / 10"),
                    ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => selectedRating = val);
                    },
                  );
                },
              ),
              TextField(
                controller: commentCtrl,
                decoration: const InputDecoration(
                  hintText: "Tulis komentar kamu...",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
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
                final provider =
                Provider.of<ReviewProvider>(context, listen: false);
                try {
                  await provider.addReview(
                    widget.movie.id,
                    selectedRating,
                    commentCtrl.text,
                  );
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Review berhasil dikirim!")),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text("Gagal: $e"),
                          backgroundColor: Colors.red),
                    );
                  }
                }
              },
              child: const Text('Kirim'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteProvider>(
      builder: (context, favoriteProvider, child) {
        final isFavorite = favoriteProvider.isFavorite(widget.movie.id);

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.movie.title),
            actions: [
              IconButton(
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
                tooltip:
                isFavorite ? 'Remove from Favorites' : 'Add to Favorites',
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
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  const Text(
                    'Overview',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    widget.movie.overview,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.justify,
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
                            ));
                      }

                      if (reviewProvider.error != null) {
                        return Text("Error: ${reviewProvider.error}",
                            style: const TextStyle(color: Colors.red));
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
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(review.comment),
                              ),
                              trailing: Text(
                                "${review.createdAt.day}/${review.createdAt.month}/${review.createdAt.year}",
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
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
      },
    );
  }
}