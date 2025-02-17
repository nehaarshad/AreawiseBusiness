import 'package:ecommercefrontend/View_Model/auth/sessionmanagementViewModel.dart';
import 'package:ecommercefrontend/models/auth_users.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommercefrontend/core/utils/routes/routes_names.dart';
import 'package:ecommercefrontend/core/utils/utils.dart';
import 'package:ecommercefrontend/repositories/auth_repositories.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
      UserModel user = UserModel.fromJson(response);
      await ref.read(sessionProvider.notifier).saveuser(user);

      if (user.role == 'admin') {
        Navigator.pushNamed(context, routesName.aHome, arguments: user);
        Utils.flushBarErrorMessage("Login Successfully as Admin", context);
      }
      // else if(user.role == 'buyer') {
      //   Navigator.pushNamed(context, routesName.bHome,arguments: user);
      //   Utils.flushBarErrorMessage("Login Successfully as Buyer", context);
      // }
      else {
        Navigator.pushNamed(context, routesName.dashboard, arguments: user.id);
        Utils.flushBarErrorMessage("Login Successfully as Seller", context);
      }
    } catch (error) {
      Utils.flushBarErrorMessage(error.toString(), context);
    } finally {
      state = false;
    }
  }
}
