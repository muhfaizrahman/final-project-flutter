import 'package:flutter/material.dart';

class UpcomingPage extends StatelessWidget {
  const UpcomingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Upcoming\n\nBuild your own list UI here.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}