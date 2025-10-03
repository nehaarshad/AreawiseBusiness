import 'dart:io';

import 'package:ecommercefrontend/models/UserDetailModel.dart';

//Multiple state management at a time in riverpod done by using CopyWith Method
class UserState {
  final UserDetailModel? user;
  final File? image;
  final bool isLoading;

  UserState({
    this.user = null,
    this.image = null,
    this.isLoading = false,
  });

  UserState copyWith({
    UserDetailModel? user,
    File? image,
    bool? isLoading,
  }) {
    return UserState(
      user: user ?? this.user,
      image: image ?? this.image,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
