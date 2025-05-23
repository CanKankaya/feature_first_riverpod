import 'package:feature_first_riverpod/features/posts/data/favorites_provider.dart';
import 'package:feature_first_riverpod/features/posts/data/post_model.dart';
import 'package:feature_first_riverpod/features/posts/data/post_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// This provider combines the posts list with favorites to filter only favorite posts
final favoritePostsProvider = Provider<AsyncValue<List<Post>>>((ref) {
  final postsAsync = ref.watch(postsProvider);
  final favorites = ref.watch(favoritesProvider);

  return postsAsync.when(
    data: (posts) => AsyncValue.data(posts.where((post) => favorites.contains(post.id)).toList()),
    loading: () => const AsyncValue.loading(),
    error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
  );
});

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritePostsProvider);
    final favoriteCount = ref.watch(favoriteCountProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Favorites ($favoriteCount)')),
      body: favoritesAsync.when(
        data: (posts) {
          if (posts.isEmpty) {
            return const Center(child: Text('No favorite posts yet'));
          }

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return FavoritePostItem(post: post);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: ${error.toString()}')),
      ),
    );
  }
}

class FavoritePostItem extends ConsumerWidget {
  final Post post;

  const FavoritePostItem({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesNotifier = ref.watch(favoritesProvider.notifier);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(post.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(post.body, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: IconButton(
          icon: const Icon(Icons.favorite, color: Colors.red),
          onPressed: () {
            favoritesNotifier.toggleFavorite(post.id);
          },
        ),
      ),
    );
  }
}
