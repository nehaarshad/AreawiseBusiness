import 'package:ecommercefrontend/models/UserDetailModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../View_Model/auth/sessionmanagementViewModel.dart';
import '../utils/routes/routes_names.dart';
import '../../models/auth_users.dart';

final splashserviceProvider = Provider((ref) {
  return splashservice(ref);
});

class splashservice {
  final Ref ref;
  splashservice(this.ref);

  Future<UserDetailModel?> getUserData() async {
    return ref.read(sessionProvider.notifier).getuser();
  }

  void checkAuth(BuildContext context, WidgetRef ref) async {
    UserDetailModel? value = await getUserData();
    await Future.delayed(Duration(seconds: 3));

    if (value == null || value.token == null || value.token == '') {
      Navigator.pushNamed(context, routesName.login);
    } else {
      if (value.role == 'Admin') {
        Navigator.pushNamed(context, routesName.aHome, arguments: value);
      }
      // else if (value.role == 'seller') {
      //   Navigator.pushNamed(context, routesName.sHome,arguments: value);
      // }
      else {
        Navigator.pushNamed(context, routesName.dashboard, arguments: value);
      }
    }
  }
}
