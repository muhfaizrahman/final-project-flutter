import 'package:flutter/material.dart';

class NowShowingPage extends StatelessWidget {
  const NowShowingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Now Showing\n\nAdd your ListView or GridView here.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
