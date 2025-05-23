import 'package:feature_first_riverpod/core/api/api_client.dart';
import 'package:feature_first_riverpod/features/users/data/user_model.dart';

class UserRepository {
  final ApiClient _apiClient;

  UserRepository(this._apiClient);

  Future<List<User>> getUsers() async {
    final jsonList = await _apiClient.getList('/users');
    return jsonList.map((json) => User.fromJson(json)).toList();
  }

  Future<User> getUser(int id) async {
    final json = await _apiClient.get('/users/$id');
    return User.fromJson(json);
  }
}
