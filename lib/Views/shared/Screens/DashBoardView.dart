import 'package:ecommercefrontend/Views/buyer_screens/buyerBottomnavigationBar.dart';
import 'package:ecommercefrontend/Views/shared/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/routes/routes_names.dart';
import '../../../models/UserDetailModel.dart';
import '../../../models/auth_users.dart';
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
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
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
      drawer: Drawer(
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
                  arguments: widget.id.toString(),
                );
              },
            ),

          ],
        ),
      ),
      body: isSeller ? SellerViews[index] : BuyerViews[index],
      bottomNavigationBar: isSeller ? SellerBottomNavigation(
                selectedIndex: index,
                onItemTapped: onTap,
              )
              : BuyerBottomNavigationBar(selectedIndex: index, onItemTapped: onTap),
    );
  }

  Widget drawerHeader(){
    return DrawerHeader(
        decoration: BoxDecoration(
          color: Appcolors.blueColor
        ),
        child: Column(
          children: [
            ProfileImageWidget(user: widget.user, height: 100, weidth: 100),
            SizedBox(height: 10,),
            Text(widget.user.username!,style: TextStyle(
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

}
