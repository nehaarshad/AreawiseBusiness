import 'package:ecommercefrontend/Views/shared/widgets/colors.dart';
import 'package:ecommercefrontend/Views/shared/widgets/logout_button.dart';
import 'package:ecommercefrontend/core/utils/routes/routes_names.dart';
import 'package:ecommercefrontend/models/auth_users.dart';
import 'package:flutter/material.dart';

class adminhomeview extends StatelessWidget {
  UserModel user;
  adminhomeview({required this.user});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(left: 68.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Admin Screen",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                logoutbutton(),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 120),

          child: Column(
            children: [
              NavigationButton(context, "Shops", routesName.ashop),
              SizedBox(height: 10),
              NavigationButton(context, "Products", routesName.aproduct),
              SizedBox(height: 10),
              NavigationButton(context, "Users", routesName.auser),
              SizedBox(height: 10),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    routesName.profile,
                    arguments: user.id,
                  );
                },
                child: Container(
                  height: 35,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Appcolors.blueColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "my profile",
                      style: TextStyle(
                        color: Appcolors.whiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget NavigationButton(BuildContext context, String title, String routesName) {
  return InkWell(
    onTap: () {
      Navigator.pushNamed(context, routesName);
    },
    child: Container(
      height: 35,
      width: 120,
      decoration: BoxDecoration(
        color: Appcolors.blueColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: Appcolors.whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}
