import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:ecommercefrontend/Views/shared/widgets/logout_button.dart';
import 'package:ecommercefrontend/models/UserDetailModel.dart';
import 'package:ecommercefrontend/models/auth_users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../View_Model/buyerViewModels/cartViewModel.dart';
import '../../core/services/notificationService.dart';
import '../../core/services/socketService.dart';
import '../buyer_screens/ShopView.dart';
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

class _adminhomeviewState extends ConsumerState<adminhomeview> with WidgetsBindingObserver {

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
    adminViews = [
      allShopsView(id: widget.user.id!,), //tick
      AllProductsview(id: widget.user.id!,),
      appHomeview(id: widget.user.id!),
      Featuredproductrequestview(id: widget.user.id.toString(),),
      UserView(),
    ];

    WidgetsBinding.instance.addObserver(this);
    _initializeServices();
    initializeCartCount();
  }

  Future<void> initializeCartCount() async {
    // Initialize cart view model to get current cart count
    final cartViewModel = ref.read(cartViewModelProvider(widget.user.id.toString()).notifier);
    await cartViewModel.getUserCart(widget.user.id.toString());
  }

  Future<void> _initializeServices() async {

    final userId = widget.user.id.toString();

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

  @override
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
          title: Padding(
            padding: const EdgeInsets.all(11),
            child:Text("BizAroundU", style: TextStyle(color:Appcolors.baseColor,fontWeight: FontWeight.bold, fontSize: 18.sp),),

          ),
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
          ],
        ),
      drawer: AdminDrawerListItems(user: widget.user,id:widget.user.id!,),
        body: SafeArea(child: adminViews[index],),
        bottomNavigationBar:adminBottomNavigationBar(selectedIndex: index, onItemTapped: onTap),
      );

  }
}
