import 'package:feature_first_riverpod/features/posts/data/post_model.dart';
import 'package:feature_first_riverpod/features/posts/data/post_providers.dart';
import 'package:feature_first_riverpod/features/posts/data/favorites_provider.dart';
import 'package:feature_first_riverpod/features/posts/presentation/add_post_screen.dart';
import 'package:feature_first_riverpod/features/users/data/user_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostListScreen extends ConsumerWidget {
  const PostListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(postsProvider);
    final favoriteCount = ref.watch(favoriteCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: [const Icon(Icons.favorite), const SizedBox(width: 4), Text('$favoriteCount')]),
          ),
        ],
      ),
      body: postsAsync.when(
        data: (posts) {
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return PostListItem(post: post);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: ${error.toString()}')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddPostScreen())).then((_) {
            // Refresh posts when returning from add post screen
            ref.invalidate(postsProvider);
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class PostListItem extends ConsumerWidget {
  final Post post;

  const PostListItem({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider(post.userId));
    final favoritesNotifier = ref.watch(favoritesProvider.notifier);
    final isFavorite = ref.watch(favoritesProvider).contains(post.id);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(post.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: IconButton(
          icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? Colors.red : null),
          onPressed: () {
            favoritesNotifier.toggleFavorite(post.id);
          },
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(post.body),
            const SizedBox(height: 8),
            userAsync.when(
              data: (user) => Text('By: ${user.name}'),
              loading: () => const Text('Loading author...'),
              error: (_, __) => const Text('Unknown author'),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => PostDetailScreen(postId: post.id)));
        },
      ),
    );
  }
}

class PostDetailScreen extends ConsumerWidget {
  final int postId;

  const PostDetailScreen({Key? key, required this.postId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postAsync = ref.watch(postProvider(postId));

    return Scaffold(
      appBar: AppBar(title: const Text('Post Details')),
      body: postAsync.when(
        data: (post) {
          final userAsync = ref.watch(userProvider(post.userId));

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                userAsync.when(
                  data:
                      (user) => Text(
                        'Author: ${user.name} (${user.email})',
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                  loading: () => const Text('Loading author...'),
                  error: (_, __) => const Text('Unknown author'),
                ),
                const SizedBox(height: 16),
                Text(post.body, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: ${error.toString()}')),
      ),
    );
  }
}
