import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:ecommercefrontend/Views/shared/widgets/logout_button.dart';
import 'package:ecommercefrontend/models/UserDetailModel.dart';
import 'package:ecommercefrontend/models/auth_users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../shared/Screens/ShopView.dart';
import '../shared/Screens/appHomeView.dart';
import '../shared/widgets/getAllProductView.dart';
import 'FeaturedProductRequestView.dart';
import 'UsersView.dart';
import 'Widgets/adminBottomNavigationView.dart';
import 'Widgets/adminDrawerView.dart';
import 'allProductsView.dart';
import 'allShopsView.dart';

class adminhomeview extends ConsumerStatefulWidget {
  UserDetailModel user;
  adminhomeview({required this.user});

  @override
  ConsumerState<adminhomeview> createState() => _adminhomeviewState();
}

class _adminhomeviewState extends ConsumerState<adminhomeview> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
      allShopsView(id: widget.user.id!,), //tick
      AllProductsview(id: widget.user.id!,),
      appHomeview(id: widget.user.id!),
      Featuredproductrequestview(id: widget.user.id.toString(),),
      UserView(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.all(11),
            child:Text("Areawise Business", style: TextStyle(color:Appcolors.blueColor,fontWeight: FontWeight.bold, fontSize: 18.sp),),

          ),
        ),
        backgroundColor: Appcolors.whiteColor,
      drawer: AdminDrawerListItems(user: widget.user,id:widget.user.id!,),
        body: SafeArea(child: adminViews[index],),
        bottomNavigationBar:adminBottomNavigationBar(selectedIndex: index, onItemTapped: onTap),
      );

  }
}
