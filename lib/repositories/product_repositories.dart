import 'dart:convert';
import 'dart:io';
import 'package:ecommercefrontend/core/network/networkChecker.dart';
import 'package:ecommercefrontend/models/NewArrivalDuration.dart';
import 'package:ecommercefrontend/models/ProductModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommercefrontend/core/network/baseapiservice.dart';
import 'package:ecommercefrontend/core/network/networkapiservice.dart';
import 'package:riverpod/riverpod.dart';
import '../View_Model/auth/sessionmanagementViewModel.dart';
import '../core/localDataSource/productLocalSource.dart';
import '../core/network/appexception.dart';
import '../core/services/app_APIs.dart';


final productProvider = Provider<ProductRepositories>((ref) {
  return ProductRepositories(ref);
});

class ProductRepositories {
  Ref ref;

  ProductRepositories(this.ref);
    baseapiservice apiservice = networkapiservice();

  Map<String, String> headers() {
    final token = ref
        .read(sessionProvider)
        ?.token;
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  ProductLocalDataSource get _localDataSource => ref.read(productLocalDataSourceProvider);

  NetworkChecker get _networkChecker => ref.read(networkCheckerProvider);

  Future<List<ProductModel>> fetchAndCacheAllProducts() async {

      if (_localDataSource.hasAllProductCachedData()) {
        print("fetch cached al products ${_localDataSource.getAllProducts()}");
        return _localDataSource.getAllProducts();
      }

      return [];

  }

  Future<List<ProductModel>> fetchAndCacheNewProducts() async {

      if (_localDataSource.hasNewProductCachedData()) {
        return _localDataSource.getNewArrivalProducts();
      }
      return [];

  }

  Future<ProductModel> addProduct(Map<String, dynamic> data, String id,
        List<File>? images,) async
    {
      try {
        dynamic response = await apiservice.PostApiWithMultiport(
            AppApis.AddProductEndPoints.replaceFirst(':id', id), data, images,
            headers());
        return ProductModel.fromJson(response);
      } catch (e) {
        print("Error:${e}");
        throw e;
      }
    }

  // Future<ProductModel> addProductViaFile(String id, File? file,) async
  // {
  //   try {
  //     dynamic response = await apiservice.PostApiWithExcelFile(
  //         AppApis.uploadProductExcelSheetEndPoints.replaceFirst(':shopid', id), file,);
  //     return ProductModel.fromJson(response);
  //   } catch (e) {
  //     print("Error:${e}");
  //     throw e;
  //   }
  // }


  Future<List<ProductModel>> getProduct(String category) async {
    final isConnected = await _networkChecker.isConnected();
    if (isConnected) {
      try {
        dynamic response = await apiservice.GetApiResponce(
          AppApis.GetProductsEndPoints.replaceFirst(':Category', category),
          headers(),
        );

        List<ProductModel> products = [];
        if (response is List) {
          products = response
              .map((p) => ProductModel.fromJson(p as Map<String, dynamic>))
              .toList();
        } else {
          products = [ProductModel.fromJson(response)];
        }
        if(category =="All"){
          await _localDataSource.cacheAllProducts(products);
        }
        print("in get all products ${products.length}");
        return products;
      } catch (e) {
        print(e);
        if (_localDataSource.hasAllProductCachedData()) {
          return _localDataSource.getProductsByCategory(category);
        }
        throw NoInternetException('No internet and no cached data available');
      }
    }
    else {
      if (_localDataSource.hasAllProductCachedData()) {
        return _localDataSource.getProductsByCategory(category);
      }
      throw NoInternetException('No internet and no cached data available');
    }
  }

  Future<ProductModel> getProductByID(String id,String userId) async {

    final isConnected = await _networkChecker.isConnected();
    final productId = int.tryParse(id);

    if (isConnected) {
      try {
        dynamic response = await apiservice.GetApiResponce(AppApis.GetProductByIDEndPoints.replaceAll(':id', id).replaceAll(':userId', userId), headers(),);
        print("on ggetting prioduct deatil ${response}");
        return ProductModel.fromJson(response);
      } catch (e) {
        if (productId != null) {
          final cached = _localDataSource.getProductById(productId);
          if (cached != null) return cached;
          throw NoInternetException("No internet and product not in cache");
        }
        throw e;
      }
    } else {
      if (productId != null) {
        final cached = _localDataSource.getProductById(productId);
        if (cached != null) return cached;
      }
      throw NoInternetException('No internet and product not in cache');
    }
  }

    Future<List<ProductModel>> getNewArrivalProduct(String Category) async {
      final isConnected = await _networkChecker.isConnected();

      if(isConnected) {
        List<ProductModel> productlist = [];
        try {
          dynamic response = await apiservice.GetApiResponce(AppApis.getNewArrivalProductsEndPoints.replaceFirst(
                  ':Category', Category), headers());
          if (response is List) {
            productlist = response.map((products) =>
                ProductModel.fromJson(products as Map<String, dynamic>),)
                .toList();
          }
          else {
            productlist = [ProductModel.fromJson(response)];
          }
          if (Category=="All"){
            await _localDataSource.cacheNewArrivalProducts(productlist);
          }
          return productlist;
        } catch (e) {
          print(e);
          if(_localDataSource.hasNewProductCachedData()){
            return _localDataSource.getNewProductsByCategory(Category);
          }
          throw NoInternetException("No internet connection");
        }
      }
      else{
        if(_localDataSource.hasNewProductCachedData()){
          return _localDataSource.getNewProductsByCategory(Category);
        }
        throw NoInternetException("No internet connection");
      }
    }

  Future<List<ProductModel>> getOnSaleProducts(String category) async {
    final isConnected = await _networkChecker.isConnected();

    if (isConnected) {
      try {
        dynamic response = await apiservice.GetApiResponce(
          AppApis.getOnSaleProductsEndPoints.replaceFirst(':Category', category),
          headers(),
        );

        List<ProductModel> products = [];
        if (response is List) {
          products = response
              .map((p) => ProductModel.fromJson(p as Map<String, dynamic>))
              .toList();
        } else {
          products = [ProductModel.fromJson(response)];
        }

        return products;
      } catch (e) {
        print(e);
        if (_localDataSource.hasAllProductCachedData()) {
          return _localDataSource.getOnSaleProductsByCategory(category);
        }
        throw NoInternetException('No internet and no cached data');
      }
    }
    else {
      if (_localDataSource.hasAllProductCachedData()) {
        return _localDataSource.getOnSaleProductsByCategory(category);
      }
      throw NoInternetException('No internet and no cached data');
    }
  }

  Future<List<ProductModel>> getUserOnSaleProducts(String id) async {
    final isConnected = await _networkChecker.isConnected();
    int? sellerId=int.tryParse(id);
    if (isConnected) {
      List<ProductModel> productlist = [];
      try {
        dynamic response = await apiservice.GetApiResponce(
            AppApis.getUserOnSaleProductsEndPoints.replaceFirst(
                ':id', id), headers());
        if (response is List) {
          return response.map((products) =>
              ProductModel.fromJson(products as Map<String, dynamic>),)
              .toList();
        }
        productlist = [ProductModel.fromJson(response)];
        return productlist;
      } catch (e) {
        print(e);
        if (_localDataSource.hasAllProductCachedData()) {
          if (sellerId != null) {
            return _localDataSource.getSellerOnSaleProducts(sellerId);
          }
        }
        throw NoInternetException('No internet and no cached data');
      }
    }
    else {
      if (_localDataSource.hasAllProductCachedData()) {
        if (sellerId != null) {
          return _localDataSource.getSellerOnSaleProducts(sellerId);
        }
      }
      throw NoInternetException('No internet and no cached data');
    }
  }

  Future<List<ProductModel?>> getProductsBySubcategory(String subcategory) async {
    final isConnected = await _networkChecker.isConnected();

    if (isConnected) {
      try {
        dynamic response = await apiservice.GetApiResponce(
          AppApis.GetProductBySubcategoryEndPoints.replaceFirst(':subcategory', subcategory),
          headers(),
        );

        List<ProductModel> products = [];
        if (response is List) {
          products = response
              .map((p) => ProductModel.fromJson(p as Map<String, dynamic>))
              .toList();
        } else {
          products = [ProductModel.fromJson(response)];
        }

        return products;
      } catch (e) {
        print(e);
        if (_localDataSource.hasAllProductCachedData()) {
          return _localDataSource.getProductsBySubcategory(subcategory);
        }
        throw NoInternetException('No internet and no cached data');
      }
    } else {

      if (_localDataSource.hasAllProductCachedData()) {
        return _localDataSource.getProductsBySubcategory(subcategory);
      }
      throw NoInternetException('No internet and no cached data');
    }
  }

  Future<dynamic> updateArrivalDuration(Map<String, dynamic> data) async {
      try {
        final jsonData = jsonEncode(data);
        dynamic response = await apiservice.UpdateApiWithJson(
            AppApis.setNewArrivalDaysEndPoints, jsonData, headers());
        return response;
      } catch (e) {
        throw e;
      }
    }
    Future<NewArrivalDuration> getArrivalDuration() async {
      try {
        dynamic response = await apiservice.GetApiResponce(
            AppApis.getNewArrivalDaysEndPoints, headers());
        return NewArrivalDuration.fromJson(response);
      } catch (e) {
        throw e;
      }
    }

  Future<List<ProductModel>> searchProduct(String name) async {
    final isConnected = await _networkChecker.isConnected();

    if (isConnected) {
      try {
        dynamic response = await apiservice.GetApiResponce(
          AppApis.getProductByNameEndPoints.replaceFirst(':name', name),
          headers(),
        );

        List<ProductModel> products = [];
        if (response is List) {
          products = response
              .map((p) => ProductModel.fromJson(p as Map<String, dynamic>))
              .toList();
        } else {
          products = [ProductModel.fromJson(response)];
        }

        return products;
      } catch (e) {
        print(e);
        if (_localDataSource.hasAllProductCachedData()) {
          return _localDataSource.searchProducts(name);
        }
        throw NoInternetException('No internet and no cached data');
      }
    } else {
      if (_localDataSource.hasAllProductCachedData()) {
        return _localDataSource.searchProducts(name);
      }
      throw NoInternetException('No internet and no cached data');
    }
  }

  Future<List<ProductModel>> getUserProduct(String id) async {
    final isConnected = await _networkChecker.isConnected();
    final sellerId = int.tryParse(id);

    if (isConnected) {
      try {
        dynamic response = await apiservice.GetApiResponce(
          AppApis.GetUserProductsEndPoints.replaceFirst(':id', id),
          headers(),
        );

        List<ProductModel> products = [];
        if (response is List) {
          products = response
              .map((p) => ProductModel.fromJson(p as Map<String, dynamic>))
              .toList();
        } else {
          products = [ProductModel.fromJson(response)];
        }

        return products;
      } catch (e) {

        if (sellerId != null) {
          return _localDataSource.getSellerProducts(sellerId);
        }
        throw e;
      }
    } else {

      if (sellerId != null && _localDataSource.hasAllProductCachedData()) {
        return _localDataSource.getSellerProducts(sellerId);
      }
      throw NoInternetException('No internet and no cached data');
    }
  }

  Future<List<ProductModel>> getShopProduct(String id) async {
    final isConnected = await _networkChecker.isConnected();
    final shopId = int.tryParse(id);

    if (isConnected) {
      try {
        dynamic response = await apiservice.GetApiResponce(
          AppApis.GetShopProductsEndPoints.replaceFirst(':id', id),
          headers(),
        );

        List<ProductModel> products = [];
        if (response is List) {
          products = response
              .map((p) => ProductModel.fromJson(p as Map<String, dynamic>))
              .toList();
        } else {
          products = [ProductModel.fromJson(response)];
        }

        return products;
      } catch (e) {
        // API failed - filter from cache by shop
        if (shopId != null) {
          return _localDataSource.getShopProducts(shopId);
        }
        throw e;
      }
    } else {
      // OFFLINE: Filter from cache by shop ID
      if (shopId != null && _localDataSource.hasAllProductCachedData()) {
        return _localDataSource.getShopProducts(shopId);
      }
      throw NoInternetException('No internet and no cached data');
    }
  }

    Future<ProductModel> updateProduct(Map<String, dynamic> data,
        String id,
        List<File>? images,) async
    {
      try {
        dynamic response = await apiservice.UpdateApiWithMultiport(
            AppApis.UpdateProductEndPoints.replaceFirst(':id', id),
            data,
            images, headers()
        );
        if (kDebugMode) {
          print(response);
        }
        return ProductModel.fromJson(response);
      } catch (e) {
        rethrow;
      }
    }

    Future<dynamic> deleteProduct(String id) async {
      try {
        dynamic response = await apiservice.DeleteApiResponce(
            AppApis.DeleteProductEndPoints.replaceFirst(':id', id), headers()
        );
        return response;
      } catch (e) {
        rethrow;
      }
    }
  }
