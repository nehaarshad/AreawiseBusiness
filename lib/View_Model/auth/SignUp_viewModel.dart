import 'package:ecommercefrontend/models/auth_users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/routes/routes_names.dart';
import '../../core/utils/utils.dart';
import '../../models/UserDetailModel.dart';
import '../../repositories/auth_repositories.dart';
import 'package:ecommercefrontend/View_Model/auth/sessionmanagementViewModel.dart';

final signupProvider = StateNotifierProvider<signupviewmodel, bool>((ref) {
  return signupviewmodel(ref);
});

class signupviewmodel extends StateNotifier<bool> {
  final Ref ref;
  signupviewmodel(this.ref) : super(false);

  Future<void> SignUpApi(Map<String,dynamic> data, BuildContext context) async {
    try {
      state = true;
      dynamic response = await ref.read(authprovider).sinupapi(data);
      print("API Response: $response");
      if (response != null) {
        UserDetailModel user= UserDetailModel.fromJson(response);
        await ref.read(sessionProvider.notifier).saveuser(user);
        print(user);
        // Utils.flushBarErrorMessage("Signup Successful", context);
        // await Future.delayed(Duration(seconds: 2));
        if (user.role == 'Admin') {
          Navigator.pushNamed(context, routesName.aHome, arguments: user);
          Utils.flushBarErrorMessage("Signup Successfully as Admin", context);
        }
        else {

          Navigator.pushNamed(context, routesName.dashboard, arguments: user);
          Utils.flushBarErrorMessage("Signup Successfully", context);
        }
      }
      else {
        Utils.flushBarErrorMessage("Signup Failed", context);
      }
    } catch (error) {
      print("Error: $error");
      Utils.flushBarErrorMessage(error.toString(), context);
    } finally {
      state = false;
    }
  }
}
