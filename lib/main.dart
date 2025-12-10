import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/pages/auth/login_page.dart';
import 'presentation/pages/auth/register_page.dart';
import 'presentation/pages/tabs_page.dart';
import 'presentation/pages/edit_profile_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://uayepjabsvmjvkjybnbz.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVheWVwamFic3ZtanZranlibmJ6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE4MDI3NDAsImV4cCI6MjA3NzM3ODc0MH0.vELug8EfuvKsTRqzRVUoCW-M0khvUAg5carMJn0gyTA',
  );

  runApp(const MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InjectionContainer.movieProvider),
        ChangeNotifierProvider(
          create: (_) => InjectionContainer.favoriteProvider,
        ),
        ChangeNotifierProvider(
          create: (_) => InjectionContainer.reviewProvider,
        ),
        ChangeNotifierProvider(
          create: (_) => InjectionContainer.ratingProvider,
        ),
      ],
      child: MaterialApp(
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
      ),
    );
  }
}
