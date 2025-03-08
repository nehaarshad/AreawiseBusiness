import 'package:ecommercefrontend/Views/buyer_screens/buyerBottomnavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/logout_button.dart';
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
  int id;
  DashboardView({required this.id});

  @override
  ConsumerState<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView> {
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
      ShopsView(),
      Wishlistview(id: widget.id),
      appHomeview(id: widget.id),
      Cartview(id: widget.id),
      profileDetailView(id: widget.id),
    ];
    SellerViews = [
      SellerShopsView(id: widget.id),
      Sellerproductsview(id: widget.id),
      appHomeview(id: widget.id),
      OrdersView(sellerId: widget.id),
      profileDetailView(id: widget.id),
    ];
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
            child: Row(
              children: [
                Text("SellerMode", style: TextStyle(fontSize: 12)),
                Switch(value: isSeller, onChanged: toggglebutton),
                SizedBox(width: 20,),
                logoutbutton(),
              ],
            ),
          ),
        ],
      ),
      body: isSeller ? SellerViews[index] : BuyerViews[index],
      bottomNavigationBar: isSeller ? SellerBottomNavigation(
                selectedIndex: index,
                onItemTapped: onTap,
              )
              : BuyerBottomNavigationBar(
                selectedIndex: index,
                onItemTapped: onTap,
              ),
    );
  }
}
