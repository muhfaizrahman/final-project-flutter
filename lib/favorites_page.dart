import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Favorites\n\nWhen your lists are ready, let users choose favorites and show them here.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}