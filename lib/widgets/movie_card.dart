import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../pages/movie_detail_page.dart';

class MovieListItem extends StatefulWidget {
  final Movie movie;
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
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.movie.isFavorite;
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    widget.onFavoriteChanged?.call(_isFavorite);
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
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    )
                  else if (widget.movie.releaseDate != null)
                    Text(
                      'Coming on: ${widget.movie.releaseDate}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                ],
              ),
            ),
            IconButton(
              tooltip: _isFavorite ? 'Remove from Favorites' : 'Add to Favorites',
              onPressed: _toggleFavorite,
              icon: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                color: _isFavorite ? Colors.red : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
