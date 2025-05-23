import 'package:feature_first_riverpod/core/api/api_provider.dart';
import 'package:feature_first_riverpod/features/posts/data/post_model.dart';
import 'package:feature_first_riverpod/features/posts/data/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postRepositoryProvider = Provider<PostRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return PostRepository(apiClient);
});

final postsProvider = FutureProvider<List<Post>>((ref) {
  final repository = ref.watch(postRepositoryProvider);
  return repository.getPosts();
});

final postProvider = FutureProvider.family<Post, int>((ref, id) {
  final repository = ref.watch(postRepositoryProvider);
  return repository.getPost(id);
});

// Provider to create a new post
final createPostProvider = FutureProvider.autoDispose.family<Post, Map<String, dynamic>>((ref, postData) async {
  final repository = ref.watch(postRepositoryProvider);
  final post = await repository.createPost(
    title: postData['title'] as String,
    body: postData['body'] as String,
    userId: postData['userId'] as int,
  );

  // Refresh the posts list
  ref.invalidate(postsProvider);

  return post;
});
