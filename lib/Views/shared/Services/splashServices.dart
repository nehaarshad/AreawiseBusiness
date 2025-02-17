import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../View_Model/auth/sessionmanagementViewModel.dart';
import '../../../core/utils/routes/routes_names.dart';
import '../../../models/auth_users.dart';

final splashserviceProvider = Provider((ref) {
  return splashservice(ref);
});

class splashservice {
  final Ref ref;
  splashservice(this.ref);

  Future<UserModel?> getUserData() async {
    return ref.read(sessionProvider.notifier).getuser();
  }

  void checkAuth(BuildContext context, WidgetRef ref) async {
    UserModel? value = await getUserData();
    await Future.delayed(Duration(seconds: 3));

    if (value == null || value.token == null || value.token == '') {
      Navigator.pushNamed(context, routesName.login);
    } else {
      if (value.role == 'admin') {
        Navigator.pushNamed(context, routesName.aHome, arguments: value);
      }
      // else if (value.role == 'seller') {
      //   Navigator.pushNamed(context, routesName.sHome,arguments: value);
      // }
      else {
        Navigator.pushNamed(context, routesName.dashboard, arguments: value.id);
      }
    }
  }
}
