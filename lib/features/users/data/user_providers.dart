import 'package:feature_first_riverpod/core/api/api_provider.dart';
import 'package:feature_first_riverpod/features/users/data/user_model.dart';
import 'package:feature_first_riverpod/features/users/data/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return UserRepository(apiClient);
});

final usersProvider = FutureProvider<List<User>>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getUsers();
});

final userProvider = FutureProvider.family<User, int>((ref, id) {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getUser(id);
});
