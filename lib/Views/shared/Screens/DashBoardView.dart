import 'package:ecommercefrontend/Views/buyer_screens/buyerBottomnavigationBar.dart';
import 'package:ecommercefrontend/Views/shared/Screens/categoryView.dart';
import 'package:ecommercefrontend/Views/shared/Screens/exploreProductsView.dart';
import 'package:ecommercefrontend/Views/shared/Screens/toSearchProduct.dart';
import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../View_Model/auth/sessionmanagementViewModel.dart';
import '../../../core/services/notificationService.dart';
import '../../../core/services/socketService.dart';
import '../../../core/utils/routes/routes_names.dart';
import '../../../core/utils/utils.dart';
import '../../../models/UserDetailModel.dart';
import '../../../models/auth_users.dart';
import '../widgets/bottomNavBar.dart';
import '../widgets/drawerList.dart';
import '../widgets/logout_button.dart';
import '../widgets/notificationBadge.dart';
import '../widgets/profileImageWidget.dart';
import '../../buyer_screens/ShopView.dart';
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

class _DashboardViewState extends ConsumerState<DashboardView> with WidgetsBindingObserver{

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

    BuyerViews = [
      ShopsView(id: widget.id),
      Exploreproductsview(userId: widget.id,category: "All",),//explore
      appHomeview(id: widget.id),
      CategoriesView(userid: widget.id),//categories
      Tosearchproduct(userid: widget.id),//SearchProductIcon
    ];
    WidgetsBinding.instance.addObserver(this);
    _initializeServices();
    // BuyerViews = [
    //   ShopsView(id: widget.id),
    //   Wishlistview(id: widget.id),
    //   appHomeview(id: widget.id),
    //   Cartview(id: widget.id),
    //   profileDetailView(id: widget.id,role: 'Buyer',),
    // ];
    // SellerViews = [
    //   SellerShopsView(id: widget.id),
    //   Sellerproductsview(id: widget.id),
    //   appHomeview(id: widget.id),
    //   OrdersView(sellerId: widget.id),
    //   profileDetailView(id: widget.id,role: 'Seller',),
    // ];
  }

  Future<void> _initializeServices() async {

    final userId = widget.id.toString();

    if (userId != null) {
      // Initialize socket service
      final socketService = ref.read(socketServiceProvider);
      await socketService.initialize(userId: userId);

      // Join user's chats
      socketService.joinChats(userId);

      // Listen to notification actions
      _listenToNotificationActions(socketService);
    }
  }

  void _listenToNotificationActions(SocketService socketService) {
    final notificationService = NotificationService();

    notificationService.notificationActionStream.listen((payload) {

    });
  }

  Widget build(BuildContext context) {
    final socketService = ref.watch(socketServiceProvider);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu,color: Appcolors.baseColor,),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        actions: [
          StreamBuilder<bool>(
            stream: Stream.periodic(Duration(seconds: 5))
                .map((_) => socketService.socket.connected),
            builder: (context, snapshot) {
              final isConnected = snapshot.data ?? false;
              return Container(
                margin: EdgeInsets.only(right: 16),
                child: Icon(
                  isConnected ? null : Icons.wifi_off,
                  color: isConnected ? null : Appcolors.baseColor,
                ),
              );
            },
          ),
          NotificationBadgeWidget(
            notificationStream: socketService.notificationStream,
            child: IconButton(
              icon: Icon(Icons.notifications_none_outlined,color: Appcolors.baseColor,),
              onPressed: (){
                Navigator.pushNamed(context, routesName.notification,arguments: widget.id.toString());
              },
            ),
          ),
          IconButton(
                    onPressed:(){

                      Navigator.pushNamed(context, routesName.cart,arguments: widget.id);

                    },
                    icon: Icon(Icons.shopping_cart_outlined,size: 18.h,color: Appcolors.baseColor,))

        ],
      ),
      drawer: DrawerListItems(user: widget.user,id: widget.id,),
      body: isSeller ? SellerViews[index] : BuyerViews[index],
      bottomNavigationBar: AppBottomNavigationBar(selectedIndex: index,onItemTapped: onTap,) );
  }


}
