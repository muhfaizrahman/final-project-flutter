import 'package:flutter/material.dart';

class TopRatedPage extends StatelessWidget {
  const TopRatedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Top Rated Movies\n\nCreate your list layout here.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}