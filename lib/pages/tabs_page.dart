import 'package:flutter/material.dart';
import 'now_showing_page.dart';
import 'upcoming_page.dart';
import 'top_rated_page.dart';
import 'favorites_page.dart';
import 'edit_profile_page.dart';

class TabsPage extends StatefulWidget {
  const TabsPage({super.key});

  @override
  State<TabsPage> createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  int _index = 0;

  final _pages = const [
    NowShowingPage(),
    UpcomingPage(),
    TopRatedPage(),
    FavoritesPage(),
    EditProfilePage(),
  ];

  final _titles = const [
    'Now Showing',
    'Upcoming',
    'Top Rated',
    'Favorites',
    'Edit Profile'
  ];

  void _onTap(int i) => setState(() => _index = i);

  void _signOut() {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_index]),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          TextButton.icon(
            onPressed: _signOut,
            icon: const Icon(
              Icons.logout,
              size: 18,
              color: Colors.red,
            ),
            label: const Text(
                'Sign out',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Now Showing'),
          BottomNavigationBarItem(icon: Icon(Icons.update), label: 'Upcoming'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Top Rated'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Edit Profile'),
        ],
      ),
    );
  }
}