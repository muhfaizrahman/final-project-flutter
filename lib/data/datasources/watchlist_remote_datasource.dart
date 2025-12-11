import 'package:supabase_flutter/supabase_flutter.dart';

class WatchlistRemoteDataSource {
  final SupabaseClient _supabase;

  WatchlistRemoteDataSource(this._supabase);

  Future<List<int>> getWatchlistMovieIds(String userId) async {
    try {
      final response = await _supabase
          .from('watchlists')
          .select('movie_id')
          .eq('user_id', userId);

      return (response as List)
          .map((item) => item['movie_id'] as int)
          .toList();

    } on PostgrestException catch (e) {
      throw Exception('Gagal mengambil watchlist (DB Error): ${e.message}');
    } catch (e) {
      throw Exception('Gagal mengambil watchlist: $e');
    }
  }

  Future<void> addWatchlist(String userId, int movieId) async {
    try {
      await _supabase.from('watchlists').insert({
        'user_id': userId,
        'movie_id': movieId,
      });
    } on PostgrestException catch (e) {
      throw Exception('Gagal menambahkan watchlist (DB Error): ${e.message}');
    } catch (e) {
      throw Exception('Gagal menambahkan watchlist: $e');
    }
  }

  Future<void> removeWatchlist(String userId, int movieId) async {
    try {
      await _supabase
          .from('watchlists')
          .delete()
          .eq('user_id', userId)
          .eq('movie_id', movieId); // <<< throwOnError() DIHAPUS
    } on PostgrestException catch (e) {
      throw Exception('Gagal menghapus watchlist (DB Error): ${e.message}');
    } catch (e) {
      throw Exception('Gagal menghapus watchlist: $e');
    }
  }

  Future<bool> isInWatchlist(String userId, int movieId) async {
    try {
      final response = await _supabase
          .from('watchlists')
          .select('id')
          .eq('user_id', userId)
          .eq('movie_id', movieId)
          .limit(1);

      return response.isNotEmpty;

    } on PostgrestException catch (e) {
      throw Exception('Gagal mengecek status watchlist (DB Error): ${e.message}');
    } catch (e) {
      throw Exception('Gagal mengecek status watchlist: $e');
    }
  }
}