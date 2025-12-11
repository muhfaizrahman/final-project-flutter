import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/usecases/get_watchlist.dart';
import '../../domain/usecases/is_in_watchlist.dart';
import '../../domain/usecases/toggle_watchlist.dart';

class WatchlistProvider extends ChangeNotifier {
  final GetWatchlist getWatchlistUC;
  final IsInWatchlist isInWatchlistUC;
  final ToggleWatchlist toggleWatchlistUC;
  final SupabaseClient supabaseClient;

  List<int> watchlist = [];
  bool isLoading = false;
  String? errorMessage;

  WatchlistProvider({
    required this.getWatchlistUC,
    required this.isInWatchlistUC,
    required this.toggleWatchlistUC,
    required this.supabaseClient,
  });

  // --- CORE FUNCTIONALITY ---

  Future<void> loadWatchlist() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      watchlist = await getWatchlistUC();

    } catch (e) {
      print('Error memuat Watchlist: $e');
      errorMessage = 'Gagal memuat daftar. Pastikan koneksi dan data Supabase benar.';
      watchlist = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Digunakan di Detail Page untuk menambah atau menghapus
  Future<void> toggleWatchlistStatus(int movieId) async { // Nama method lebih jelas
    try {
      await toggleWatchlistUC(movieId);
      // Muat ulang daftar untuk memastikan tampilan WatchlistPage ter-update
      await loadWatchlist();
    } catch (e) {
      print('Error saat toggle Watchlist: $e');
      errorMessage = 'Gagal mengubah status Watchlist.';
      notifyListeners();
    }
  }

  // Digunakan di WatchlistPage untuk menghapus item
  Future<void> removeWatchlist(int movieId) async {
    try {
      // Menggunakan toggle karena fungsinya sama dengan removeItem
      await toggleWatchlistUC(movieId);

      // Update daftar dan UI
      await loadWatchlist();

    } catch (e) {
      print('Error saat menghapus Watchlist: $e');
      errorMessage = 'Gagal menghapus item dari Watchlist.';
      notifyListeners();
    }
  }

  // Digunakan di Detail Page untuk mengecek status awal tombol
  Future<bool> isMovieInWatchlist(int movieId) async { // Nama method lebih jelas
    try {
      return await isInWatchlistUC(movieId);
    } catch (e) {
      print('Error cek Watchlist status: $e');
      return false;
    }
  }
}