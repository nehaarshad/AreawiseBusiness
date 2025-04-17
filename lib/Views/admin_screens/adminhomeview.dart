import 'package:ecommercefrontend/Views/shared/widgets/colors.dart';
import 'package:ecommercefrontend/Views/shared/widgets/logout_button.dart';
import 'package:ecommercefrontend/models/UserDetailModel.dart';
import 'package:ecommercefrontend/models/auth_users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../shared/Screens/ShopView.dart';
import '../shared/Screens/appHomeView.dart';
import '../shared/widgets/getAllProductView.dart';
import 'FeaturedProductRequestView.dart';
import 'UsersView.dart';
import 'adminBottomNavigationView.dart';

class adminhomeview extends ConsumerStatefulWidget {
  UserDetailModel user;
  adminhomeview({required this.user});

  @override
  ConsumerState<adminhomeview> createState() => _adminhomeviewState();
}

class _adminhomeviewState extends ConsumerState<adminhomeview> {
  late List<Widget> adminViews = [];
  int index = 2;

  void onTap(int selectedIndex) {
    setState(() {
      index = selectedIndex;
    });
  }


  @override
  void initState() {
    super.initState();
    // Initialize pages with user ID
    adminViews = [
      ShopsView(),
      ProductsView(userid: widget.user.id!,),
      appHomeview(id: widget.user.id!),
      //profileDetailView(id: widget.user.id!),
      Featuredproductrequestview(),
      UserView(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.all(11),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Areawise Business",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                logoutbutton(),
              ],
            ),
          ),
        ),
        backgroundColor: Appcolors.whiteColor,
        body: SafeArea(child: adminViews[index],),
        bottomNavigationBar:adminBottomNavigationBar(selectedIndex: index, onItemTapped: onTap),
      ),
    );
  }
}

// Widget NavigationButton(BuildContext context, String title, String routesName) {
//   return InkWell(
//     onTap: () {
//       Navigator.pushNamed(context, routesName);
//     },
//     child: Container(
//       height: 35,
//       width: 120,
//       decoration: BoxDecoration(
//         color: Appcolors.blueColor,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Center(
//         child: Text(
//           title,
//           style: TextStyle(
//             color: Appcolors.whiteColor,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     ),
//   );
// }
// Padding(
// padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 120),
//
// child: Column(
// children: [
// NavigationButton(context, "Shops", routesName.ashop),
// SizedBox(height: 10),
// NavigationButton(context, "Products", routesName.aproduct),
// SizedBox(height: 10),
// NavigationButton(context, "Users", routesName.auser),
// SizedBox(height: 10),
// InkWell(
// onTap: () {
// Navigator.pushNamed(
// context,
// routesName.profile,
// arguments: user.id,
// );
// },
// child: Container(
// height: 35,
// width: 120,
// decoration: BoxDecoration(
// color: Appcolors.blueColor,
// borderRadius: BorderRadius.circular(10),
// ),
// child: Center(
// child: Text(
// "my profile",
// style: TextStyle(
// color: Appcolors.whiteColor,
// fontWeight: FontWeight.bold,
// ),
// ),
// ),
// ),
// ),
// ],
// ),
// ),
