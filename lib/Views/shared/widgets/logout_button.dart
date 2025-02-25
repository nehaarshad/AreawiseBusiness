import 'package:ecommercefrontend/Views/shared/widgets/colors.dart';
import 'package:ecommercefrontend/core/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../View_Model/auth/sessionmanagementViewModel.dart';
import '../../../core/utils/routes/routes_names.dart';

class logoutbutton extends ConsumerWidget {
  const logoutbutton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userpreferences = ref.read(sessionProvider.notifier);

    return InkWell(
      onTap: () async {
        final success = await userpreferences.logout();
        if (success) {
          Utils.flushBarErrorMessage("LogOut Completed!", context);
          await Future.delayed(Duration(seconds: 1));
          Navigator.pushNamed(context, routesName.login);
        } else {
          Utils.flushBarErrorMessage("LogOut Not Completed!", context);
        }
      },
      child:Text("Logout ",style: TextStyle(color: Appcolors.blueColor,fontWeight: FontWeight.w500),),

    );
  }
}
