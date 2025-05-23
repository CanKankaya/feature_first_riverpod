import 'package:feature_first_riverpod/core/api/api_client.dart';
import 'package:feature_first_riverpod/features/posts/data/post_model.dart';

class PostRepository {
  final ApiClient _apiClient;

  PostRepository(this._apiClient);

  Future<List<Post>> getPosts() async {
    final jsonList = await _apiClient.getList('/posts');
    return jsonList.map((json) => Post.fromJson(json)).toList();
  }

  Future<Post> getPost(int id) async {
    final json = await _apiClient.get('/posts/$id');
    return Post.fromJson(json);
  }

  Future<Post> createPost({required String title, required String body, required int userId}) async {
    final data = {'title': title, 'body': body, 'userId': userId};

    final json = await _apiClient.post('/posts', data);
    return Post.fromJson(json);
  }
}
