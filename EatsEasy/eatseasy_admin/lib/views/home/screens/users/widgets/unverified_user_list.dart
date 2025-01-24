import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:eatseasy_admin/common/shimmers/foodlist_shimmer.dart';
import 'package:eatseasy_admin/hooks/fetch_users.dart';
import 'package:eatseasy_admin/models/users_model.dart';
import 'package:eatseasy_admin/views/home/screens/users/widgets/user_tile.dart';

class UnVerifiedUsersList extends HookWidget {
  const UnVerifiedUsersList({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch all unverified users at once (no pagination)
    final data = fetchUsers(false, 1, 1000); // Fetch a larger limit for all unverified users
    final users = data.users;
    final isLoading = data.isLoading;
    final error = data.error;

    if (isLoading) {
      return const FoodsListShimmer();
    }

    if (users == null || users.isEmpty) {
      return const Center(
        child: Text("No unverified users found"),
      );
    }

    if (error != null) {
      return const Center(
        child: Text("An error occurred"),
      );
    }

    // Display the list of all unverified users without pagination
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        User user = users[index];
        return UserTile(
          context: context,
          user: user,
          index: index,
        );
      },
    );
  }
}
