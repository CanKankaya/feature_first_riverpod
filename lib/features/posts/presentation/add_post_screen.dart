import 'package:feature_first_riverpod/features/posts/data/post_providers.dart';
import 'package:feature_first_riverpod/features/users/data/user_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPostScreen extends ConsumerStatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends ConsumerState<AddPostScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  int? _selectedUserId;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _submitPost() async {
    if (_titleController.text.isEmpty || _bodyController.text.isEmpty || _selectedUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill in all fields')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final postData = {'title': _titleController.text, 'body': _bodyController.text, 'userId': _selectedUserId!};

      await ref.read(createPostProvider(postData).future);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Post created successfully!')));
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error creating post: ${e.toString()}')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(usersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Add New Post')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: usersAsync.when(
          data: (users) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: 'Select User'),
                  value: _selectedUserId,
                  items:
                      users.map((user) {
                        return DropdownMenuItem(value: user.id, child: Text(user.name));
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedUserId = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _bodyController,
                  decoration: const InputDecoration(labelText: 'Body', border: OutlineInputBorder()),
                  maxLines: 5,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitPost,
                  child: _isLoading ? const CircularProgressIndicator() : const Text('Create Post'),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text('Error loading users: ${error.toString()}')),
        ),
      ),
    );
  }
}
