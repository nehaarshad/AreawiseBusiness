import 'package:ecommercefrontend/Views/shared/widgets/profileImageWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../View_Model/auth/sessionmanagementViewModel.dart';
import '../../../core/utils/routes/routes_names.dart';
import '../../../core/utils/utils.dart';
import '../../../models/UserDetailModel.dart';
import 'colors.dart';

class DrawerListItems extends ConsumerWidget {
  UserDetailModel user;
  int id; //UserId
   DrawerListItems({required this.user,required this.id});

  @override
  Widget build(BuildContext context,WidgetRef ref) {


    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          drawerHeader(),
          drawerItems(
            icon: Icons.chat,
            title: 'Chats',
            onTap: () {
              Navigator.pushNamed(
                context,
                routesName.chatList,
                arguments: id.toString(),
              );
            },
          ),
          drawerItems(
              icon: Icons.logout,
              title: 'Logout',
              onTap:(){
                logout(context,ref);
              }
          ),
        ],
      ),
    );
  }

  Widget drawerHeader(){
    return DrawerHeader(
        decoration: BoxDecoration(
            color: Appcolors.blueColor
        ),
        child: Column(
          children: [
            ProfileImageWidget(user: user, height: 100, width: 100),
            SizedBox(height: 10,),
            Text(user.username!,style: TextStyle(
              color: Appcolors.whiteColor,
              fontSize: 15,
            ),)
          ],

        )
    );
  }

  Widget drawerItems({required IconData icon, required String title, required GestureTapCallback onTap}){
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  Future<void> logout(BuildContext context , WidgetRef ref) async {
    final userpreferences = ref.read(sessionProvider.notifier);
    final success = await userpreferences.logout();

    if (success) {
      Utils.flushBarErrorMessage("LogOut Completed!", context);
      await Future.delayed(Duration(seconds: 1));
      Navigator.pushNamedAndRemoveUntil(
        context,
        routesName.login,
            (route) => false,
      );
    } else {
      Utils.flushBarErrorMessage("LogOut Not Completed!", context);
    }
  }
}
