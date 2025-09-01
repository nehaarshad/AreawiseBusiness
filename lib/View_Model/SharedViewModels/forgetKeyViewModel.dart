import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommercefrontend/core/utils/routes/routes_names.dart';
import 'package:ecommercefrontend/core/utils/utils.dart';
import 'package:ecommercefrontend/repositories/auth_repositories.dart';
import 'package:flutter/material.dart';

final forgetKeyVMProvider = StateNotifierProvider<forgetKeyViewModel, bool>((ref) {
  return forgetKeyViewModel(ref);
});

class forgetKeyViewModel extends StateNotifier<bool> {
  final Ref ref;
  forgetKeyViewModel(this.ref) : super(false) {}

  Future<void> forgetKey(Map<String,dynamic> data, BuildContext context) async {
    state = true;

    try {
      dynamic response = await ref.read(authprovider).forgetPassword(data);
      Utils.flushBarErrorMessage('Password Reset Successfully!', context);
      Navigator.pushNamed(context, routesName.login);
    } catch (error) {
      Utils.flushBarErrorMessage('Unable to Reset Password', context);
    } finally {
      state = false;
    }
  }
}
