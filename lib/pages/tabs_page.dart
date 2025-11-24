import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'now_showing_page.dart';
import 'upcoming_page.dart';
import 'top_rated_page.dart';
import 'favorites_page.dart';
import 'edit_profile_page.dart';
import '../presentation/providers/favorite_provider.dart';
import '../presentation/providers/movie_provider.dart';

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
    'Upcoming Movies',
    'Top Rated',
    'Favorites',
    'Edit Profile'
  ];

  @override
  void initState() {
    super.initState();
    // Initialize favorites and movies when user logs in
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final favoriteProvider = Provider.of<FavoriteProvider>(context, listen: false);
      final movieProvider = Provider.of<MovieProvider>(context, listen: false);
      
      favoriteProvider.initialize();
      movieProvider.initialize();
    });
  }

  void _onTap(int i) => setState(() => _index = i);

  Future<void> _signOut() async {
    try {
      // Clear favorites and movies before signing out
      final favoriteProvider = Provider.of<FavoriteProvider>(context, listen: false);
      final movieProvider = Provider.of<MovieProvider>(context, listen: false);
      
      favoriteProvider.clear();
      movieProvider.clear();
      
      await Supabase.instance.client.auth.signOut();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logout berhasil.')),
        );
        Navigator.pushReplacementNamed(context, '/login');
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saat logout: ${e.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan tak terduga: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
          BottomNavigationBarItem(icon: Icon(Icons.update), label: 'Upcoming Movies'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Top Rated'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Edit Profile'),
        ],
      ),
    );
  }
}