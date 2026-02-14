import 'package:ecommercefrontend/Views/shared/Screens/categoryView.dart';
import 'package:ecommercefrontend/Views/shared/Screens/exploreProductsView.dart';
import 'package:ecommercefrontend/Views/shared/Screens/toSearchProduct.dart';
import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../View_Model/buyerViewModels/cartViewModel.dart';
import '../../../core/services/notificationService.dart';
import '../../../core/services/socketService.dart';
import '../../../core/utils/routes/routes_names.dart';
import '../../../models/UserDetailModel.dart';
import '../../sellerscrens/SellerShopView.dart';
import '../../sellerscrens/selectOperationView.dart';
import '../widgets/bottomNavBar.dart';
import '../widgets/cartBadgeWidget.dart';
import '../widgets/drawerList.dart';
import '../widgets/notificationBadge.dart';
import '../../buyer_screens/ShopView.dart';
import '../widgets/selectAreafloatingButton.dart';
import 'appHomeView.dart';
import 'chatsListView.dart';

class DashboardView extends ConsumerStatefulWidget {
  final UserDetailModel user;
  final int id; //UserId
  const DashboardView({required this.id, required this.user});

  @override
  ConsumerState<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView> with WidgetsBindingObserver{

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int index = 0;
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
      appHomeview(id: widget.id),
      Exploreproductsview(userId: widget.id,category: "All",condition: null,onsale: false,),//
      Selectoperationview(userid: widget.id.toString(),),
      CategoriesView(userid: widget.id),//categories
      ChatsListView(userId: widget.id.toString()),
    ];
    WidgetsBinding.instance.addObserver(this);
    _initializeServices();
    initializeCartCount();
  }

  Future<void> initializeCartCount() async {
    // Initialize cart view model to get current cart count
    final cartViewModel = ref.read(cartViewModelProvider(widget.id.toString()).notifier);
    await cartViewModel.getUserCart(widget.id.toString());
  }

  Future<void> _initializeServices() async {

    final userId = widget.id.toString();

    if (userId != null) {
      final socketService = ref.read(socketServiceProvider);
      await socketService.initialize(userId: userId);
      socketService.joinChats(userId);
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

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {

          if (index != 0) {
            setState(() {
              index = 0; // Go back to home tab
            });
          }
          else{
            SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              setState(() {
                onTap(2);

              });
            },
            shape: CircleBorder(),
            backgroundColor: Appcolors.baseColor,
            child: Icon(
              Icons.add,
              color: Appcolors.whiteSmoke,
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.menu,color: Appcolors.baseColor,),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),

          automaticallyImplyLeading: false,
          actions: [
            StreamBuilder<bool>(
              stream: Stream.periodic(Duration(seconds: 3))
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
            CartBadgeWidget(
              userId: widget.id,
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    routesName.cart,
                    arguments: widget.id,
                  );
                },
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  color: Appcolors.baseColor,
                ),
              ),
            ),

            const SizedBox(width: 8),

          ],
        ),
        drawer: DrawerListItems(user: widget.user,id: widget.id,),
        body: isSeller ? SellerViews[index] : BuyerViews[index],
        bottomNavigationBar: AppBottomNavigationBar(selectedIndex: index,onItemTapped: onTap,)
      ),
    );
  }


}
