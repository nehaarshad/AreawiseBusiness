import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Views/shared/widgets/notificatioPermissionFunction.dart';
import '../../core/services/socketService.dart';
import '../../core/utils/routes/routes_names.dart';
import '../../core/utils/notifyUtils.dart';
import '../../models/UserDetailModel.dart';
import '../../repositories/auth_repositories.dart';
import 'package:ecommercefrontend/View_Model/auth/sessionmanagementViewModel.dart';

final signupProvider = StateNotifierProvider<signupviewmodel, bool>((ref) {
  return signupviewmodel(ref);
});

class signupviewmodel extends StateNotifier<bool> {
  final NotificationPermission _notificationPermission = NotificationPermission();
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
        final socketService = ref.read(socketServiceProvider);
        await socketService.initialize(userId: user.id.toString());
        print(user);
        if (user.role == 'Admin') {
          Navigator.pushNamed(context, routesName.aHome, arguments: user);
        }
        else {

          Navigator.pushNamed(context, routesName.dashboard, arguments: user);

        }
        await _notificationPermission.requestNotificationPermissions(context);
      }
      else {
        Utils.flushBarErrorMessage("Signup Failed", context);
      }

    } catch (error) {
      print("Error: $error");
      Utils.flushBarErrorMessage('Error During Registration, Try Later!', context);
    } finally {
      state = false;
    }
  }
}
