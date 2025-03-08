import 'package:ecommercefrontend/core/utils/routes/routes_names.dart';
import 'package:flutter/material.dart';
import '../../../Views/admin_screens/FeaturedProductRequestView.dart';
import '../../../Views/shared/widgets/getAllProductView.dart';
import '../../../Views/admin_screens/adminhomeview.dart';
import '../../../Views/auth/screens/login_View.dart';
import '../../../Views/auth/screens/signUp_View.dart';
import '../../../Views/buyer_screens/deliveryAddress.dart';
import '../../../Views/sellerscrens/UpdateShopView.dart';
import '../../../Views/sellerscrens/createAds.dart';
import '../../../Views/shared/Screens/DashBoardView.dart';
import '../../../Views/shared/Screens/ShopView.dart';
import '../../../Views/admin_screens/UsersView.dart';
import '../../../Views/sellerscrens/SellerShopView.dart';
import '../../../Views/sellerscrens/addProductView.dart';
import '../../../Views/sellerscrens/addShopView.dart';
import '../../../Views/sellerscrens/updateProductView.dart';
import '../../../Views/shared/Screens/EditProfileView.dart';
import '../../../Views/shared/Screens/ProductDetailView.dart';
import '../../../Views/shared/Screens/ShopDetailView.dart';
import '../../../Views/shared/Screens/UserProfileView.dart';
import '../../../Views/sellerscrens/orderDetailView.dart';
import '../../../Views/shared/Screens/splashScreen.dart';
import '../../../models/ProductModel.dart';
import '../../../models/UserDetailModel.dart';
import '../../../models/auth_users.dart';
import '../../../models/ordersRequestModel.dart';
import '../../../models/shopModel.dart';

class Routes {
  static Route<dynamic> createroutes(RouteSettings setting) {
    var arg;
    if (setting.arguments is Map<String, dynamic>) {
      arg = setting.arguments as Map<String, dynamic>;
    }
    arg = setting.arguments;

    switch (setting.name) {
      case (routesName.splash):
        return MaterialPageRoute(builder: (BuildContext context) => splashView(),);

      case (routesName.login):
        return MaterialPageRoute(builder: (BuildContext context) => login_view(),);

      case (routesName.signUp):
        return MaterialPageRoute(builder: (BuildContext context) => const signUp_View(),);

      case (routesName.aHome):
        final user = arg as UserModel;
        return MaterialPageRoute(builder: (BuildContext context) => adminhomeview(user: user),);

      case (routesName.dashboard):
        final id = arg as int;
        return MaterialPageRoute(builder: (BuildContext context) => DashboardView(id: id),);

      case (routesName.auser):
        return MaterialPageRoute(builder: (BuildContext context) => const UserView(),);

      case (routesName.afeature):
        return MaterialPageRoute(builder: (BuildContext context) => const Featuredproductrequestview(),);


      case (routesName.ashop):
        return MaterialPageRoute(builder: (BuildContext context) => const ShopsView());

      case (routesName.aproduct):
        int id=arg as int;
        return MaterialPageRoute(builder: (BuildContext context) => ProductsView(userid:id),);

      case (routesName.sEditShop):
        int id = arg['shopid'] as int;
        String userid = arg['userid'] as String;
        return MaterialPageRoute(builder: (BuildContext context) => updateShopView(id: id,userid:userid),);

      case (routesName.sShop):
        final user = arg as int;
        return MaterialPageRoute(builder: (BuildContext context) => SellerShopsView(id: user),);

      case (routesName.sAddShop):
        final user = arg as int;
        return MaterialPageRoute(builder: (BuildContext context) => addShopView(id: user));

      case (routesName.sAddProduct):
        final shop = arg as ShopModel;
        return MaterialPageRoute(
          builder: (BuildContext context) => addProductView(shop: shop),
        );

      case (routesName.sEditProduct):
        final id = arg as ProductModel;
        return MaterialPageRoute(
          builder: (BuildContext context) => updateProductView(product: id),
        );

      case (routesName.orderDetails):
        final orderRequest = arg as OrdersRequestModel;
        return MaterialPageRoute(
          builder: (BuildContext context) => OrderDetailView(orderRequest: orderRequest),
        );

      case (routesName.deliveryAddress):
        int CartId = arg['CartId'] as int;
        String userid = arg['userid'] as String;
        return MaterialPageRoute(
          builder: (BuildContext context) => deliveryAddress(userid: userid,cartId: CartId),
        );

      case (routesName.productdetail):
        final id = arg['id'] as int;
        final product = arg['product'] as ProductModel;
        return MaterialPageRoute(
          builder:
              (BuildContext context) =>
                  productDetailView(userid: id, product: product),
        );

      case (routesName.shopdetail):
        final shop = arg as ShopModel;
        return MaterialPageRoute(
          builder: (BuildContext context) => ShopDetailView(shop: shop),
        );

      case (routesName.profile):
        final id = arg as int;
        return MaterialPageRoute(
          builder: (BuildContext context) => profileDetailView(id: id),
        );

      case (routesName.createAds):
        final id = arg as String;
        return MaterialPageRoute(
          builder: (BuildContext context) => createAds(SellerId: id),
        );

      case (routesName.editprofile):
        final id = arg as int;
        return MaterialPageRoute(
          builder: (BuildContext context) => editProfile(id: id),
        );

      default:
        return MaterialPageRoute(
          builder: (_) {
            return Scaffold(body: Center(child: Text("No Page Found!")));
          },
        );
    }
  }
}
