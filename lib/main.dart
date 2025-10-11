import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'tabs_page.dart';
import 'edit_profile_page.dart';
import 'now_showing_page.dart';

void main() {
  runApp(const MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catalog Movie App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        '/home': (_) => const TabsPage(),
        '/edit-profile': (_) => const EditProfilePage(),
      },
    );
  }
}