import 'package:flutter/material.dart';

class RatingInputWidget extends StatefulWidget {
  final int? initialRating;
  final Function(int) onRatingSelected;
  final bool enabled;

  const RatingInputWidget({
    super.key,
    this.initialRating,
    required this.onRatingSelected,
    this.enabled = true,
  });

  @override
  State<RatingInputWidget> createState() => _RatingInputWidgetState();
}

class _RatingInputWidgetState extends State<RatingInputWidget> {
  late double _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = (widget.initialRating ?? 5).toDouble();
  }

  @override
  void didUpdateWidget(RatingInputWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialRating != oldWidget.initialRating &&
        widget.initialRating != null) {
      setState(() {
        _currentRating = widget.initialRating!.toDouble();
      });
    }
  }

  Color _getRatingColor(double rating) {
    if (rating <= 3) return Colors.red;
    if (rating <= 5) return Colors.orange;
    if (rating <= 7) return Colors.amber;
    return Colors.green;
  }

  String _getRatingLabel(double rating) {
    if (rating <= 3) return 'Poor';
    if (rating <= 5) return 'Fair';
    if (rating <= 7) return 'Good';
    if (rating <= 9) return 'Great';
    return 'Excellent!';
  }

  @override
  Widget build(BuildContext context) {
    final ratingColor = _getRatingColor(_currentRating);
    final ratingLabel = _getRatingLabel(_currentRating);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Large Rating Display
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: ratingColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: ratingColor.withOpacity(0.3), width: 2),
          ),
          child: Column(
            children: [
              // Star Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final starValue = (index + 1) * 2;
                  final isFilled = _currentRating >= starValue;
                  final isHalfFilled =
                      _currentRating >= starValue - 1 &&
                      _currentRating < starValue;

                  return Icon(
                    isHalfFilled
                        ? Icons.star_half
                        : (isFilled ? Icons.star : Icons.star_border),
                    size: 36,
                    color: ratingColor,
                  );
                }),
              ),
              const SizedBox(height: 16),
              // Large Number
              Text(
                _currentRating.toInt().toString(),
                style: TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  color: ratingColor,
                  height: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'out of 10',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              // Rating Label
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: ratingColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  ratingLabel,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: ratingColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Slider
        Column(
          children: [
            Slider(
              value: _currentRating,
              min: 1,
              max: 10,
              divisions: 9,
              label: _currentRating.toInt().toString(),
              activeColor: ratingColor,
              inactiveColor: ratingColor.withOpacity(0.2),
              onChanged: widget.enabled
                  ? (value) {
                      setState(() {
                        _currentRating = value;
                      });
                      widget.onRatingSelected(value.toInt());
                    }
                  : null,
            ),
            // Scale Markers
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(10, (index) {
                  final value = index + 1;
                  final isSelected = _currentRating.toInt() == value;
                  return Text(
                    value.toString(),
                    style: TextStyle(
                      fontSize: isSelected ? 14 : 12,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected ? ratingColor : Colors.grey,
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
