import 'dart:developer' as developer;

import 'package:ecommercefrontend/View_Model/auth/sessionmanagementViewModel.dart';
import 'package:ecommercefrontend/models/UserDetailModel.dart';
import 'package:ecommercefrontend/models/auth_users.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommercefrontend/core/utils/routes/routes_names.dart';
import 'package:ecommercefrontend/core/utils/notifyUtils.dart';
import 'package:ecommercefrontend/repositories/auth_repositories.dart';
import 'package:flutter/material.dart';

import '../../core/services/socketService.dart';

final loginProvider = StateNotifierProvider<LoginViewModel, bool>((ref) {
  return LoginViewModel(ref);
});

class LoginViewModel extends StateNotifier<bool> {
  final Ref ref;
  LoginViewModel(this.ref) : super(false) {}

  Future<void> loginApi(dynamic data, BuildContext context) async {
    state = true;

    try {
      dynamic response = await ref.read(authprovider).loginapi(data);
      UserDetailModel user= UserDetailModel.fromJson(response);
      await ref.read(sessionProvider.notifier).saveuser(user);
      developer.log("Logged in user:${user}");
      if (user.role == 'Admin') {
        Navigator.pushNamed(context, routesName.aHome, arguments: user);
      }
      else {

        Navigator.pushNamed(context, routesName.dashboard, arguments: user);
      }

    } catch (error) {
      print(error);
      developer.log("Logged in user:${error}");
      Utils.flushBarErrorMessage("Incorrect Usename or Password", context);
    } finally {
      state = false;
    }
  }
}
