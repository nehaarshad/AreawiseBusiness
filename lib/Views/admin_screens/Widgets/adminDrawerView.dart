import 'package:ecommercefrontend/Views/shared/widgets/profileImageWidget.dart';
import 'package:ecommercefrontend/core/utils/CapitalizesFirst.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../View_Model/auth/sessionmanagementViewModel.dart';
import '../../../core/utils/routes/routes_names.dart';
import '../../../core/utils/notifyUtils.dart';
import '../../../models/UserDetailModel.dart';
import '../../../core/utils/colors.dart';

class AdminDrawerListItems extends ConsumerWidget {
  UserDetailModel user;
  int id; //UserId
  AdminDrawerListItems({required this.user,required this.id});

  @override
  Widget build(BuildContext context,WidgetRef ref) {


    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          drawerHeader(context),
          drawerItems(
            icon: Icons.ad_units_outlined,
            title: "Advertisements",
            onTap: () {
              Navigator.pushNamed(
                context,
                routesName.createAds,
                arguments: id.toString(),
              );
            },
          ),
          drawerItems(
            icon: Icons.category_outlined,
            title: 'Categories',
            onTap: () {
              Navigator.pushNamed(
                context,
                routesName.categories,
              );
            },
          ),
          drawerItems(
            icon: Icons.miscellaneous_services_sharp,
            title: 'Services',
            onTap: () {
              Navigator.pushNamed(
                context,
                routesName.services,
                arguments: "Admin"
              );
            },
          ),
          drawerItems(
            icon: Icons.favorite_border_outlined,
            title: 'Favorite Products',
            onTap: () {
              Navigator.pushNamed(
                context,
                routesName.favorite,
                arguments: id,
              );
            },
          ),
          drawerItems(
            icon: Icons.shopping_cart_outlined,
            title: 'Cart',
            onTap: () {
              Navigator.pushNamed(
                context,
                routesName.cart,
                arguments: id,
              );
            },
          ),
          drawerItems(
            icon: Icons.history_outlined,
            title: 'Orders History',
            onTap: () {
              Navigator.pushNamed(
                context,
                routesName.history,
                arguments: id.toString()
              );
            },
          ),
          drawerItems(
            icon: Icons.settings,
            title: 'Settings',
            onTap: () {
              Navigator.pushNamed(
                context,
                routesName.updateAttributes,
              );
            },
          ),
          drawerItems(
            icon: Icons.feedback_outlined,
            title: 'Feedbacks',
            onTap: () {
              Navigator.pushNamed(
                context,
                routesName.feedbacks,
              );
            },
          ),
          drawerItems(
              icon: Icons.logout,
              title: 'SignOut',
              onTap:(){
                logout(context,ref);
              }
          ),
        ],
      ),
    );
  }

  Widget drawerHeader(BuildContext context){
    return DrawerHeader(
      
        decoration: BoxDecoration(
            color: Appcolors.baseColor
        ),
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: (){
              Navigator.pushNamed(
                context,
                routesName.profile,
                arguments:user.id,
              );
            },
            child: Column(
              children: [
                ProfileImageWidget(user: user, height: 70.h, width: 100.w),
                
                Text(capitalizeFirst(user.username!),
                  
                  style: TextStyle(
                  color: Appcolors.whiteSmoke,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  
                ),)
              ],
          
            ),
          ),
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
     // Utils.flushBarErrorMessage("LogOut Completed!", context);
      await Future.delayed(Duration(seconds: 1));
      Navigator.pushNamedAndRemoveUntil(
        context,
        routesName.login,
            (route) => false,
      );
    } else {
      Utils.flushBarErrorMessage("LogOut Failed!", context);
    }
  }
}
