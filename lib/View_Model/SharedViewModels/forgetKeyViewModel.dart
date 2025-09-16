import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommercefrontend/core/utils/routes/routes_names.dart';
import 'package:ecommercefrontend/core/utils/notifyUtils.dart';
import 'package:ecommercefrontend/repositories/auth_repositories.dart';
import 'package:flutter/material.dart';

import '../../core/utils/dialogueBox.dart';

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
      await DialogUtils.showSuccessDialog(context,"Password reset ");  Navigator.pushNamed(context, routesName.login);
    } catch (error) {
      Utils.flushBarErrorMessage('Unable to Reset Password', context);
    } finally {
      state = false;
    }
  }
}
