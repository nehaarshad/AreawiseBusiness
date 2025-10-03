import 'package:ecommercefrontend/Views/shared/widgets/profileImageWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../View_Model/auth/sessionmanagementViewModel.dart';
import '../../../core/utils/routes/routes_names.dart';
import '../../../core/utils/notifyUtils.dart';
import '../../../models/UserDetailModel.dart';
import '../../../core/utils/colors.dart';

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
          drawerHeader(context),
          // drawerItems(
          //   icon: Icons.business_center_outlined,
          //   title: 'Seller Account',
          //   onTap: () {
          //     final params={
          //       'user':user,
          //       'id':id
          //     };
          //     Navigator.pushNamed(
          //       context,
          //       routesName.account,
          //       arguments: params,
          //     );
          //   },
          // ),
          drawerItems(
            icon: Icons.chat_outlined,
            title: 'Inbox',
            onTap: () {
              Navigator.pushNamed(
                context,
                routesName.chatList,
                arguments: id.toString(),
              );
            },
          ),
          drawerItems(
            icon: Icons.store_mall_directory_outlined,
            title: "My Shop",
            onTap: () {
              Navigator.pushNamed(
                context,
                routesName.sShop,
                arguments: id,
              );
            },
          ),
          drawerItems(
            icon: Icons.shopping_bag_outlined,
            title: "My Product",
            onTap: () {
              Navigator.pushNamed(
                context,
                routesName.sProducts,
                arguments: id,
              );
            },
          ),
          drawerItems(
            icon: Icons.history_outlined,
            title: 'My Orders',
            onTap: () {
              Navigator.pushNamed(
                  context,
                  routesName.history,
                  arguments: id.toString()
              );
            },
          ),
          drawerItems(
            icon: Icons.favorite_border_outlined,
            title: 'Wishlist',
            onTap: (){
              Navigator.pushNamed(context, routesName.favorite,arguments:id);
            },
          ),
          drawerItems(
            icon: Icons.receipt_long_outlined,
            title: "Order's Requests",
            onTap: () {
              Navigator.pushNamed(
                  context,
                  routesName.OrderRequests,
                  arguments: id
              );
            },
          ),
          drawerItems(
            icon: Icons.account_balance_wallet_outlined,
            title: 'Payment Account',
            onTap: (){
              Navigator.pushNamed(
                context,
                routesName.sellerAccounts,
                arguments:id,
              );
            },
          ),
          drawerItems(
            icon: Icons.help_center_outlined,
            title: 'Help',
            onTap: (){
              Navigator.pushNamed(context, routesName.FAQ);
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
                Text(user.username!,style: TextStyle(
                  color: Appcolors.whiteSmoke,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500
                ),)
              ],
          
            ),
          ),
        )
    );
  }

  Widget drawerItems({required IconData icon, required String title, required GestureTapCallback onTap}){
    return ListTile(
      leading: Icon(icon,),
      title: Text(title),
      onTap: onTap,
    );
  }

  Future<void> logout(BuildContext context , WidgetRef ref) async {
    final userpreferences = ref.read(sessionProvider.notifier);
    final success = await userpreferences.logout();

    if (success) {
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
