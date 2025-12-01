import 'package:ecommercefrontend/models/hiveModels/shopHiveModel.dart';
import 'package:ecommercefrontend/models/mappers/shopMapper.dart';
import 'package:ecommercefrontend/models/shopModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final shopLocalDataSourceProvider = Provider<ShopLocalDataSource>((ref) {

  final dataSource = ShopLocalDataSource();
  dataSource.init();
  return dataSource;
});

class ShopLocalDataSource {
  static const String allShopBox = 'all_shop_cache';

  late Box<ShopHiveModel> _shopBox;

  Future<void> init() async {
    _shopBox = await Hive.openBox<ShopHiveModel>(allShopBox);
  }

  Future<void> cacheAllShops(List<ShopModel> shops) async {
    // Clear old cache
    await _shopBox.clear();

    // Save all products
    for (var shop in shops) {
      if (shop.id != null) {
        ///convert to hive model for storage
        final hiveModel = ShopMapper.toHiveModel(shop);
        await _shopBox.put(shop.id, hiveModel);  // Use product ID as key
      }
    }
  }

  List<ShopModel> getAllShops() {
    return _shopBox.values
        .map((hive) => ShopMapper.fromHiveModel(hive))
        .toList();
  }

  /// FILTER BY SELLER ID
  List<ShopModel> getSellerShops(int sellerId) {
    return _shopBox.values
        .where((s) => s.userId == sellerId)
        .map((hive) => ShopMapper.fromHiveModel(hive))
        .toList();
  }

  /// FILTER BY shop ID
  ShopModel getShopById(int id) {
    final hiveModel = _shopBox.get(id);
    return ShopMapper.fromHiveModel(hiveModel != null ? hiveModel : null) ;
  }

  /// SEARCH  BY NAME
  List<ShopModel> searchShop(String query) {
    final lowerQuery = query.toLowerCase();
    return _shopBox.values
        .where((s) =>
    s.shopname?.toLowerCase().contains(lowerQuery) == true)
        .map((hive) => ShopMapper.fromHiveModel(hive))
        .toList();
  }

  bool hasCachedData() {
    return _shopBox.isNotEmpty;
  }

}