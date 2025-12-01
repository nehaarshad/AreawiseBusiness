import 'package:ecommercefrontend/models/featureModel.dart';
import 'package:ecommercefrontend/models/hiveModels/featureHiveModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/ProductModel.dart';
import '../../models/hiveModels/productHiveModel.dart';
import '../../models/mappers/featureProductMapper.dart';
import '../../models/mappers/productMapper.dart';

final productLocalDataSourceProvider = Provider<ProductLocalDataSource>((ref) {

  final dataSource = ProductLocalDataSource();
  dataSource.init();
  return dataSource;
});

class ProductLocalDataSource {
  static const String allProductsBox = 'all_products_cache';
  static const String featureProductsBox = 'feature_products_cache';
  static const String newArrivalProductsBox = 'new_products_cache';

  late Box<ProductHiveModel> _productBox;
  late Box<featureProductHiveModel> _featureProductBox;
  late Box<ProductHiveModel> _newProductBox;

  Future<void> init() async {
    _productBox = await Hive.openBox<ProductHiveModel>(allProductsBox);
    _featureProductBox = await Hive.openBox<featureProductHiveModel>(featureProductsBox);
    _newProductBox = await Hive.openBox<ProductHiveModel>(newArrivalProductsBox);
  }

  /// API call caches all products)
  Future<void> cacheAllProducts(List<ProductModel> products) async {
    // Clear old cache
    await _productBox.clear();

    // Save all products
    for (var product in products) {
      if (product.id != null) {
        ///convert to hive model for storage
        final hiveModel = ProductMapper.toHiveModel(product);
        await _productBox.put(product.id, hiveModel);  // Use product ID as key
      }
  }
  }

  Future<void> cacheFeaturedProducts(List<featureModel> products) async {
    // Clear old cache
    await _featureProductBox.clear();

    // Save all products
    for (var product in products) {
      if (product.id != null) {
        ///convert to hive model for storage
        final hiveModel = FeatureProductMapper.toHiveModel(product);
        print("to hive model feature products ${hiveModel}");
        await _featureProductBox.put(product.id, hiveModel);  // Use product ID as key
      }
    }
  }

  Future<void> cacheNewArrivalProducts(List<ProductModel> products) async {
    // Clear old cache
    await _newProductBox.clear();

    // Save all products
    for (var product in products) {
      if (product.id != null) {
        ///convert to hive model for storage
        final hiveModel = ProductMapper.toHiveModel(product);
        await _newProductBox.put(product.id, hiveModel);  // Use product ID as key
      }
    }

  }

  /// GET ALL CACHE PRODUCTS FOR EXPLORE VIEW WITHOUT ANY FILTER & CONVERT FROM HIVEMODEL TO PRODUCTMODEL FOR DISPLAY
  List<ProductModel> getAllProducts() {
    return _productBox.values
        .map((hive) => ProductMapper.fromHiveModel(hive))
        .toList();
  }

  List<ProductModel> getNewArrivalProducts() {
    return _newProductBox.values
        .map((hive) => ProductMapper.fromHiveModel(hive))
        .toList();
  }

  List<featureModel> getFeaturedProducts() {
    return _featureProductBox.values
        .map((hive) => FeatureProductMapper.fromHiveModel(hive))
        .toList();
  }

  /// FILTER BY CATEGORY NAME
  List<featureModel> getFeaturedProductsByCategory(String categoryName) {
    if (categoryName == 'All') {
      return getFeaturedProducts();
    }

    return _featureProductBox.values
        .where((p) => p.product!.categoryName! == categoryName)
        .map((hive) => FeatureProductMapper.fromHiveModel(hive)).toList();
  }

  List<featureModel> getRequestedFeaturedProducts() {

    return _featureProductBox.values
        .where((p) => p.status == "Requested")
        .map((hive) => FeatureProductMapper.fromHiveModel(hive)).toList();
  }

  /// FILTER BY SELLER ID
  List<featureModel> getSellerFeaturesProducts(int sellerId) {
    return _featureProductBox.values
        .where((p) => p.userID == sellerId)
        .map((hive) => FeatureProductMapper.fromHiveModel(hive))
        .toList();
  }


  /// FILTER BY CATEGORY NAME
  List<ProductModel> getProductsByCategory(String categoryName) {
    if (categoryName == 'All') {
      return getAllProducts();
    }

    return _productBox.values
        .where((p) => p.categoryName == categoryName)
           .map((hive) => ProductMapper.fromHiveModel(hive)).toList();
  }

  List<ProductModel> getNewProductsByCategory(String categoryName) {
    if (categoryName == 'All') {
      return getNewArrivalProducts();
    }

    return _newProductBox.values
        .where((p) => p.categoryName == categoryName)
        .map((hive) => ProductMapper.fromHiveModel(hive)).toList();
  }


  /// FILTER BY SELLER ID
  List<ProductModel> getSellerProducts(int sellerId) {
    return _productBox.values
        .where((p) => p.seller == sellerId)
        .map((hive) => ProductMapper.fromHiveModel(hive))
        .toList();
  }


  /// FILTER BY SHOP ID
  List<ProductModel> getShopProducts(int shopId) {
    return _productBox.values
        .where((p) => p.shopid == shopId)
        .map((hive) => ProductMapper.fromHiveModel(hive))
        .toList();
  }

  /// FILTER BY SUBCATEGORY
  List<ProductModel> getProductsBySubcategory(String subcategoryName) {
    return _productBox.values
        .where((p) => p.subcategoryName == subcategoryName)
        .map((hive) => ProductMapper.fromHiveModel(hive))
        .toList();
  }


  /// GET PRODUCTS ON SALE
  List<ProductModel> getOnSaleProducts() {
    return _productBox.values
        .where((p) => p.onSale == true)
        .map((hive) => ProductMapper.fromHiveModel(hive))
        .toList();
  }


  /// GET PRODUCTS ON SALE BY CATEGORY
  List<ProductModel> getOnSaleProductsByCategory(String categoryName) {
    if (categoryName.toLowerCase() == 'all') {
      return getOnSaleProducts();
    }

    return _productBox.values
        .where((p) => p.onSale == true &&
        p.categoryName?.toLowerCase() == categoryName.toLowerCase())
        .map((hive) => ProductMapper.fromHiveModel(hive))
        .toList();
  }

  List<ProductModel> getSellerOnSaleProducts(int sellerid) {

    return _productBox.values
        .where((p) => p.onSale == true &&
        p.seller == sellerid)
        .map((hive) => ProductMapper.fromHiveModel(hive))
        .toList();
  }


  /// GET PRODUCT BY ID
  ProductModel? getProductById(int id) {
    final hiveModel = _productBox.get(id);
    return hiveModel != null ? ProductMapper.fromHiveModel(hiveModel) : null;
  }


  /// SEARCH PRODUCTS BY NAME
  List<ProductModel> searchProducts(String query) {
    final lowerQuery = query.toLowerCase();
    return _productBox.values
        .where((p) =>
          p.name?.toLowerCase().contains(lowerQuery) == true
              ||
          p.subtitle?.toLowerCase().contains(lowerQuery) == true)
              .map((hive) => ProductMapper.fromHiveModel(hive))
              .toList();
  }

  bool hasAllProductCachedData() {
    return _productBox.isNotEmpty;
  }

  bool hasNewProductCachedData() {
    return _newProductBox.isNotEmpty;
  }

  bool hasFeaturedProductCachedData() {
    return _featureProductBox.isNotEmpty;
  }


  Future<void> clearCache() async {
    await _productBox.clear();
    await _newProductBox.clear();
    await _featureProductBox.clear();
  }

}