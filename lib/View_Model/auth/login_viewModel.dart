import 'dart:developer' as developer;

import 'package:ecommercefrontend/View_Model/auth/sessionmanagementViewModel.dart';
import 'package:ecommercefrontend/models/UserDetailModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommercefrontend/core/utils/routes/routes_names.dart';
import 'package:ecommercefrontend/core/utils/notifyUtils.dart';
import 'package:ecommercefrontend/repositories/auth_repositories.dart';
import 'package:flutter/material.dart';

import '../../Views/shared/widgets/notificatioPermissionFunction.dart';
import '../../core/services/socketService.dart';
import '../../core/utils/dialogueBox.dart';

final loginProvider = StateNotifierProvider<LoginViewModel, bool>((ref) {
  return LoginViewModel(ref);
});

class LoginViewModel extends StateNotifier<bool> {
  final Ref ref;
  final NotificationPermission _notificationPermission = NotificationPermission();

  LoginViewModel(this.ref) : super(false) {}

  Future<void> loginApi(dynamic data, BuildContext context) async {
    state = true;

    try {
      dynamic response = await ref.read(authprovider).loginapi(data);
      if (response.toString() !="Incorrect Password" && response.toString() !="Incorrect Username") {
        UserDetailModel user = UserDetailModel.fromJson(response);
        await ref.read(sessionProvider.notifier).saveuser(user);
        final socketService = ref.read(socketServiceProvider);
        await socketService.initialize(userId: user.id.toString());
        if (user.role == 'Admin') {
          Navigator.pushNamedAndRemoveUntil(context, routesName.aHome,(route)=>false, arguments: user);
        }
        else {
          Navigator.pushNamedAndRemoveUntil(context, routesName.dashboard,(route)=>false, arguments: user);
        }
        await _notificationPermission.requestNotificationPermissions(context);
      }
      else{
        await DialogUtils.showErrorDialog(context,response.toString());
      }
    } catch (error) {
      print(error);
      await DialogUtils.showErrorDialog(context,"Incorrect username or password");
    } finally {
      state = false;
    }
  }
}
