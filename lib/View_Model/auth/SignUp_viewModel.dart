import 'package:ecommercefrontend/models/auth_users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/routes/routes_names.dart';
import '../../core/utils/utils.dart';
import '../../repositories/auth_repositories.dart';

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
        UserModel user = UserModel.fromJson(response);
        print(user);
        Utils.flushBarErrorMessage("Signup Successful", context);
        await Future.delayed(Duration(seconds: 2));
        Navigator.pushNamed(context, routesName.login);
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
