import 'package:ecommercefrontend/Views/buyer_screens/buyerBottomnavigationBar.dart';
import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../View_Model/auth/sessionmanagementViewModel.dart';
import '../../../core/utils/routes/routes_names.dart';
import '../../../core/utils/utils.dart';
import '../../../models/UserDetailModel.dart';
import '../../../models/auth_users.dart';
import '../widgets/drawerList.dart';
import '../widgets/logout_button.dart';
import '../widgets/profileImageWidget.dart';
import 'ShopView.dart';
import '../../buyer_screens/CartView.dart';
import '../../buyer_screens/WishListView.dart';
import '../../sellerscrens/OrdersView.dart';
import '../../sellerscrens/SellerProductsView.dart';
import '../../sellerscrens/SellerShopView.dart';
import '../../sellerscrens/sellerBottomNavigationView.dart';
import 'appHomeView.dart';
import 'UserProfileView.dart';

class DashboardView extends ConsumerStatefulWidget {
  UserDetailModel user;
  int id; //UserId
  DashboardView({required this.id, required this.user});

  @override
  ConsumerState<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int index = 2;
  bool isSeller = false;

  void toggglebutton(bool value) {
    setState(() {
      isSeller = value;
      index = 2;
    });
  }

  void onTap(int selectedIndex) {
    setState(() {
      index = selectedIndex;
    });
  }

  late List<Widget> BuyerViews = [];
  late List<Widget> SellerViews = [];

  @override
  void initState() {
    super.initState();
    // Initialize pages with user ID
    BuyerViews = [
      ShopsView(id: widget.id),
      Wishlistview(id: widget.id),
      appHomeview(id: widget.id),
      Cartview(id: widget.id),
      profileDetailView(id: widget.id,role: 'Buyer',),
    ];
    SellerViews = [
      SellerShopsView(id: widget.id),
      Sellerproductsview(id: widget.id),
      appHomeview(id: widget.id),
      OrdersView(sellerId: widget.id),
      profileDetailView(id: widget.id,role: 'Seller',),
    ];
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding:  EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 10.w),
            child: Row(
              children: [
                Text("SellerMode", style: TextStyle(fontSize: 12.sp)),
                Switch(value: isSeller, onChanged: toggglebutton),
              ],
            ),
          ),
        ],
      ),
      drawer: DrawerListItems(user: widget.user,id: widget.id,),
      body: isSeller ? SellerViews[index] : BuyerViews[index],
      bottomNavigationBar: isSeller ? SellerBottomNavigation(
                selectedIndex: index,
                onItemTapped: onTap,
              )
              : BuyerBottomNavigationBar(selectedIndex: index, onItemTapped: onTap),
    );
  }


}
