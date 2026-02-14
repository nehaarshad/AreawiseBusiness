import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:ecommercefrontend/core/utils/routes/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Selectoperationview extends StatelessWidget {
  final String userid;
  const Selectoperationview({super.key, required this.userid});

  @override
  Widget build(BuildContext context) {
    // Define your operations list
    final operations = [
      {
        "title": "Add New Shop",
        "icon": Icons.store,
        "onTap": () {
          int? userId=int.tryParse(userid);
          Navigator.pushNamed(context,routesName.sAddShop, arguments: userId);
        }
      },
      {
        "title": "Add Your Service",
        "icon": Icons.design_services,
        "onTap": () {
          Navigator.pushNamed(context,routesName.selectService, arguments: userid);
        }
      },
      {
        "title": "Add New Product",
        "icon": Icons.add_box,
        "onTap": () {
          Navigator.pushNamed(context, routesName.selectShop, arguments: userid);
        }
      },
      {
        "title": "View My Shops",
        "icon": Icons.storefront,
        "onTap": () {
          int? userId=int.tryParse(userid);
          Navigator.pushNamed(context, routesName.sShop, arguments: userId);
        }
      },
      {
        "title": "View My Services",
        "icon": Icons.miscellaneous_services_rounded,
        "onTap": () {
          int? userId=int.tryParse(userid);
          Navigator.pushNamed(context,routesName.sServices, arguments: userId);
        }
      },
      {
        "title": "View My Products",
        "icon": Icons.list_alt,
        "onTap": () {
          int? userId=int.tryParse(userid);
          Navigator.pushNamed(context,routesName.sProducts, arguments: userId);
        }
      },
    ];

    return Scaffold(
      body: ListView.builder(
        itemCount: operations.length,
        itemBuilder: (context, index) {
          final op = operations[index];
          return  Column(
            children: [
              SizedBox(
                height: 50.h,
                child: ListTile(
                    leading: Icon(op["icon"] as IconData, color: Appcolors.baseColor),
                    title: Text(op["title"] as String),
                    trailing: Icon(Icons.arrow_forward_ios_rounded,size: 15,color: Colors.grey,),
                    onTap: op["onTap"] as void Function(),
                  ),
              ),
              Divider(),
            ],
          );
        },
      ),
    );
  }
}
