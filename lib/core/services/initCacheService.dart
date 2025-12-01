import 'package:ecommercefrontend/core/localDataSource/shopLocalDataSource.dart';
import 'package:ecommercefrontend/core/localDataSource/userLocalSource.dart';
import 'package:ecommercefrontend/models/hiveModels/cartHiveModel.dart';
import 'package:ecommercefrontend/models/hiveModels/cartItemsHiveModel.dart';
import 'package:ecommercefrontend/models/hiveModels/featureHiveModel.dart';
import 'package:ecommercefrontend/models/hiveModels/orderHiveModel.dart';
import 'package:ecommercefrontend/models/hiveModels/orderReminderHiveModel.dart';
import 'package:ecommercefrontend/models/hiveModels/orderRequestHiveModel.dart';
import 'package:ecommercefrontend/models/hiveModels/shopHiveModel.dart';
import 'package:ecommercefrontend/models/hiveModels/userHiveModel.dart';
import 'package:ecommercefrontend/repositories/ShopRepositories.dart';
import 'package:ecommercefrontend/repositories/UserDetailsRepositories.dart';
import 'package:ecommercefrontend/repositories/featuredRepositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/hiveModels/ImageHiveModel.dart';
import '../../models/hiveModels/adsHiveModel.dart';
import '../../models/hiveModels/categoryHiveModel.dart';
import '../../models/hiveModels/productHiveModel.dart';
import '../../models/hiveModels/reviewHiveModel.dart';
import '../../models/hiveModels/subcategoryHiveModel.dart';
import '../../repositories/adRepository.dart';
import '../../repositories/categoriesRepository.dart';
import '../../repositories/product_repositories.dart';
import '../../repositories/sellerOrdersRepository.dart';
import '../localDataSource/advertisementLocalSource.dart';
import '../localDataSource/categoryLocalSource.dart';
import '../localDataSource/ordersLocalDataStorage.dart';
import '../localDataSource/productLocalSource.dart';

final cacheserviceProvider = Provider((ref) {
  return cacheInitializationService(ref);
});

class cacheInitializationService {
  final Ref ref;
  cacheInitializationService(this.ref);

  Future<void > initCache() async {

    await Hive.close();
    // Initialize Hive
    await Hive.initFlutter();

    await registerAdapters();

    await initializeBoxes();

  }

  Future<void> registerAdapters() async{
    // Register adapters
    Hive.registerAdapter(ProductHiveModelAdapter()); //id->0
    Hive.registerAdapter(ImageHiveModelAdapter());  //id-> 1
    Hive.registerAdapter(ReviewHiveModelAdapter());  // id ->10
    Hive.registerAdapter(CategoryHiveModelAdapter());  //id -> 3
    Hive.registerAdapter(AdsHiveModelAdapter());  // id -> 2
    Hive.registerAdapter(SubcategoryHiveModelAdapter());  //id -> 7
    Hive.registerAdapter(UserHiveModelAdapter());  // id -> 14
    Hive.registerAdapter(ShopHiveModelAdapter()); //id -> 11
    Hive.registerAdapter(AddressHiveModelAdapter());  // id -> 15
    Hive.registerAdapter(OrderHiveModelAdapter()); // id -> 6
    Hive.registerAdapter(OrderReminderHiveModelAdapter()); // id -> 8
    Hive.registerAdapter(OrderRequestHiveModelAdapter()); // id -> 9
    Hive.registerAdapter(featureProductHiveModelAdapter()); // id -> 12
    Hive.registerAdapter(CartItemHiveModelAdapter()); // id -> 5
    Hive.registerAdapter(CartHiveModelAdapter());
  }

  Future<void> initializeBoxes() async{
    await ref.read(adsLocalDataSourceProvider).init();
    await ref.read(categoryLocalDataSourceProvider).init();
    await ref.read(productLocalDataSourceProvider).init();
    await ref.read(shopLocalDataSourceProvider).init();
    await ref.read(userLocalDataSourceProvider).init();
    await ref.read(ordersLocalDataSourceProvider).init();
  }

  Future<void> cacheLocalData() async{
    /// for advertisements
     await ref.read(adProvider).fetchCacheAllAdvertisements();

    /// for categories
     await ref.read(categoryProvider).fetchAndCacheAllCategories();

    /// for shops
     await ref.read(shopProvider).fetchAndCacheAllShops();

     /// for user
     await ref.read(userProvider).fetchAndCacheAllUsers();

    /// for sellerOrders
     await ref.read(sellerOrderProvider).fetchAndCacheCustomerOrders();

    /// for orderHistory
     await ref.read(sellerOrderProvider).fetchAndCacheSellerOrders();

    /// for chat's
    // await ref.read(adProvider).fetchCacheAllAdvertisements();

    ///for products
    await ref.read(productProvider).fetchAndCacheAllProducts();
    await ref.read(productProvider).fetchAndCacheNewProducts();
    await ref.read(featureProvider).fetchAndCacheFeaturedProducts();
  }
}
