import 'package:feature_first_riverpod/features/users/data/user_model.dart';
import 'package:feature_first_riverpod/features/users/data/user_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserListScreen extends ConsumerWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: usersAsync.when(
        data: (users) {
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return UserListItem(user: user);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: ${error.toString()}')),
      ),
    );
  }
}

class UserListItem extends StatelessWidget {
  final User user;

  const UserListItem({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(child: Text(user.name[0])),
        title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [const SizedBox(height: 4), Text('@${user.username}'), const SizedBox(height: 4), Text(user.email)],
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => UserDetailScreen(userId: user.id)));
        },
      ),
    );
  }
}

class UserDetailScreen extends ConsumerWidget {
  final int userId;

  const UserDetailScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider(userId));

    return Scaffold(
      appBar: AppBar(title: const Text('User Details')),
      body: userAsync.when(
        data: (user) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(radius: 40, child: Text(user.name[0], style: const TextStyle(fontSize: 32))),
                ),
                const SizedBox(height: 24),
                _buildInfoRow('Name', user.name),
                _buildInfoRow('Username', '@${user.username}'),
                _buildInfoRow('Email', user.email),
                _buildInfoRow('Phone', user.phone),
                _buildInfoRow('Website', user.website),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: ${error.toString()}')),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 80, child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
