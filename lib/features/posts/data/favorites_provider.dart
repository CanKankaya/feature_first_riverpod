import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesNotifier extends StateNotifier<List<int>> {
  FavoritesNotifier() : super([]);

  bool isFavorite(int postId) {
    return state.contains(postId);
  }

  void toggleFavorite(int postId) {
    if (isFavorite(postId)) {
      state = state.where((id) => id != postId).toList();
    } else {
      state = [...state, postId];
    }
  }

  int get count => state.length;
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<int>>((ref) {
  return FavoritesNotifier();
});

// This provider returns the count of favorite posts
final favoriteCountProvider = Provider<int>((ref) {
  return ref.watch(favoritesProvider).length;
});
