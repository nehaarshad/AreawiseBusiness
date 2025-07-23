import 'package:ecommercefrontend/Views/admin_screens/addCategory.dart';
import 'package:ecommercefrontend/Views/admin_screens/addUserView.dart';
import 'package:ecommercefrontend/Views/admin_screens/searchUserView.dart';
import 'package:ecommercefrontend/Views/buyer_screens/CartView.dart';
import 'package:ecommercefrontend/Views/buyer_screens/WishListView.dart';
import 'package:ecommercefrontend/Views/buyer_screens/orderPlaceMessageView.dart';
import 'package:ecommercefrontend/Views/shared/Screens/changePasswordView.dart';
import 'package:ecommercefrontend/Views/shared/Screens/historyView.dart';
import 'package:ecommercefrontend/Views/shared/Screens/searchProductView.dart';
import 'package:ecommercefrontend/core/utils/routes/routes_names.dart';
import 'package:ecommercefrontend/models/categoryModel.dart';
import 'package:flutter/material.dart';
import '../../../Views/admin_screens/FeaturedProductRequestView.dart';
import '../../../Views/admin_screens/FeaturedProducts.dart';
import '../../../Views/admin_screens/appCategories.dart';
import '../../../Views/admin_screens/appSubcategories.dart';
import '../../../Views/admin_screens/updateDeliveryOrderAttributes.dart';
import '../../../Views/sellerscrens/getSellerFeatureProducts.dart';
import '../../../Views/sellerscrens/sellerShopDetailView.dart';
import '../../../Views/shared/Screens/chatsListView.dart';
import '../../../Views/shared/Screens/forgetPasswordView.dart';
import '../../../Views/shared/Screens/searchShopView.dart';
import '../../../Views/shared/widgets/getAllProductView.dart';
import '../../../Views/admin_screens/adminhomeview.dart';
import '../../../Views/auth/screens/login_View.dart';
import '../../../Views/auth/screens/signUp_View.dart';
import '../../../Views/buyer_screens/deliveryAddress.dart';
import '../../../Views/sellerscrens/UpdateShopView.dart';
import '../../../Views/admin_screens/createAds.dart';
import '../../../Views/shared/Screens/DashBoardView.dart';
import '../../../Views/shared/Screens/ShopView.dart';
import '../../../Views/admin_screens/UsersView.dart';
import '../../../Views/sellerscrens/SellerShopView.dart';
import '../../../Views/sellerscrens/addProductView.dart';
import '../../../Views/sellerscrens/addShopView.dart';
import '../../../Views/sellerscrens/updateProductView.dart';
import '../../../Views/shared/Screens/EditProfileView.dart';
import '../../../Views/shared/Screens/ProductDetailView.dart';
import '../../../Views/buyer_screens/ShopDetailView.dart';
import '../../../Views/shared/Screens/UserProfileView.dart';
import '../../../Views/sellerscrens/orderDetailView.dart';
import '../../../Views/shared/Screens/splashScreen.dart';
import '../../../Views/shared/widgets/getSellerAds.dart';
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
        final user = arg as UserDetailModel;
        return MaterialPageRoute(builder: (BuildContext context) => adminhomeview(user: user),);

      case (routesName.updateAttributes):
        return MaterialPageRoute(builder: (BuildContext context) => UpdateAttributes(),);

      case (routesName.dashboard):
        final user = arg as UserDetailModel;
        return MaterialPageRoute(builder: (BuildContext context) => DashboardView(id: user.id!,user: user,),);

      case (routesName.confirmOrder):
        final user = arg as UserDetailModel;
        return MaterialPageRoute(builder: (BuildContext context) => Orderplacemessageview(user: user,),);

      case (routesName.auser):
        return MaterialPageRoute(builder: (BuildContext context) => const UserView(),);

      case (routesName.changePassword):
        String id = arg as String;
        return MaterialPageRoute(builder: (BuildContext context) =>  Changepasswordview(id: id),);

      case (routesName.profile):
        int id = arg['id'] as int;
        String role = arg['role'] as String;
        return MaterialPageRoute(builder: (BuildContext context) =>  profileDetailView(id: id,role: role,),);


      case (routesName.ashop):
        int id=arg as int;
        return MaterialPageRoute(builder: (BuildContext context) =>  ShopsView(id: id,));

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

      case (routesName.SellerShopDetailView):
        final shop = arg as ShopModel;
        return MaterialPageRoute(
          builder: (BuildContext context) => SellerShopDetailView(shop: shop),
        );

      case (routesName.categories):
        return MaterialPageRoute(
          builder: (BuildContext context) => AllCategories(),
        );

      case (routesName.addCategory):
        return MaterialPageRoute(
          builder: (BuildContext context) => addCategory(),
        );

      case (routesName.subcategories):
        Category category=arg as Category;
        return MaterialPageRoute(
          builder: (BuildContext context) => SubcategoriesView(category: category,),
        );

      case (routesName.search):
        final id = arg['id'] as int;
        String search=arg['search'] as String;
        return MaterialPageRoute(
          builder: (BuildContext context) => searchView(search: search,userid: id,),
        );

      case (routesName.searchUser):

        String search=arg as String;
        return MaterialPageRoute(
          builder: (BuildContext context) => searchUserView(search: search),
        );

      case (routesName.searchShop):
        final id = arg['id'] as int;
        String search=arg['search'] as String;
        return MaterialPageRoute(
          builder: (BuildContext context) => searchShopView(search: search,userid: id,),
        );

      case (routesName.history):
        String id=arg as String;
        return MaterialPageRoute(
          builder: (BuildContext context) => OrdersHistoryView(id: id,),
        );

      case (routesName.featuredProducts):
        final id = arg as String;
        return MaterialPageRoute(
          builder: (BuildContext context) => UserFeaturedProducts(sellerId: id,),
        );

      case (routesName.addUser):
        return MaterialPageRoute(
          builder: (BuildContext context) => addUser(),
        );

      case (routesName.forget):
        return MaterialPageRoute(
          builder: (BuildContext context) => Forgetpasswordview(),
        );

    case (routesName.activeADS):
    final id = arg as String;
    return MaterialPageRoute(
    builder: (BuildContext context) => UserAdsView(sellerId: id,),
    );

      case (routesName.requestfeature):
        final id = arg as String;
        return MaterialPageRoute(
          builder: (BuildContext context) => Featuredproductrequestview(id: id,),
        );

      case (routesName.activefeature):
        final id = arg as String;
        return MaterialPageRoute(
          builder: (BuildContext context) => Featuredproducts(id: id,),
        );

      case (routesName.favorite):
        final id = arg as int;
        return MaterialPageRoute(
          builder: (BuildContext context) => Wishlistview(id: id,),
        );

      case (routesName.cart):
        final id = arg as int;
        return MaterialPageRoute(
          builder: (BuildContext context) => Cartview(id: id),
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

      case (routesName.chatList):
        final id = arg as String;
        return MaterialPageRoute(
          builder: (BuildContext context) => ChatsListView(userId: id),
        );

      // case (routesName.chatView):
      //   final chatId = arg['chatId'] as String;
      //   final userId = arg['userId'] as String;
      //   // return MaterialPageRoute(
      //   //  // builder: (BuildContext context) => ChatView(chatId: chatId,userId:userId),
      //   // );

      default:
        return MaterialPageRoute(
          builder: (_) {
            return Scaffold(body: Center(child: Text("No Page Found!")));
          },
        );
    }
  }
}
