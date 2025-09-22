import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import '../../models/UserDetailModel.dart';
import '../../repositories/UserDetailsRepositories.dart';

final searchUserViewModelProvider = StateNotifierProvider<searchUserViewModel, AsyncValue<List<UserDetailModel?>>>((
    ref,
    ) {
  return searchUserViewModel(ref);
});

class searchUserViewModel extends StateNotifier<AsyncValue<List<UserDetailModel?>>> {
  final Ref ref;
  searchUserViewModel(this.ref) : super(AsyncValue.loading()) ;

  Future<void> searchuser(String name) async {
    try {
      List<UserDetailModel?> users = await ref.read(userProvider).getuserbyname(name);
      if (users.isEmpty) {
        state = const AsyncValue.data([]); // Explicit empty list
      } else {
        state = AsyncValue.data(users.where((p) => p != null).toList());
      }
      state = AsyncValue.data(users.isEmpty ? [] : users);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

