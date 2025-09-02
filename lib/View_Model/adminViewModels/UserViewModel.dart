import 'dart:async';
import 'package:ecommercefrontend/core/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/utils/routes/routes_names.dart';
import '../../models/UserDetailModel.dart';
import '../../repositories/UserDetailsRepositories.dart';
import '../auth/sessionmanagementViewModel.dart';
import 'package:flutter/material.dart';

final UserViewModelProvider = StateNotifierProvider<UserViewModel, AsyncValue<List<UserDetailModel?>>>((
      ref,
    ) {
      return UserViewModel(ref);
    });

class UserViewModel extends StateNotifier<AsyncValue<List<UserDetailModel?>>> {
  final Ref ref;
  UserViewModel(this.ref) : super(AsyncValue.loading()) {
    getallusers();
  }

  Future<void> getallusers() async {
    try {
      List<UserDetailModel?> users = await ref.read(userProvider).getAllUsers();
      state = AsyncValue.data(users.isEmpty ? [] : users);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> deleteusers(String id, BuildContext context) async {
    try {
      print("delete user Id ${id}");
      final currentUserId = ref.read(sessionProvider)?.id;
      print("Current user Id ${currentUserId}");

      await ref.read(userProvider).deleteUser(id);
      getallusers();

      if (currentUserId != null) {
        if (currentUserId.toString() == id) {
          // User deleted their own account
          final SharedPreferences sp = await SharedPreferences.getInstance();
          await sp.clear();
          Utils.flushBarErrorMessage("Account Deleted", context);
          print("SharedPreferences cleared: ${sp.getString('token')}");
          await Future.delayed(Duration(seconds: 1));
          Navigator.pushNamedAndRemoveUntil(
            context,
            routesName.login,
                (route) => false,
          );
        } else {
          // User deleted someone else's account
          Utils.flushBarErrorMessage("User Deleted Successfully", context);
        }
      } else {
        Utils.flushBarErrorMessage("Failed to Delete - No current user", context);
      }

    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      Utils.flushBarErrorMessage("Failed to Delete", context);
    }
  }
}

