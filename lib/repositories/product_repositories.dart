import 'dart:io';

import 'package:ecommercefrontend/models/ProductModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommercefrontend/core/network/baseapiservice.dart';
import 'package:ecommercefrontend/core/network/networkapiservice.dart';
import 'package:riverpod/riverpod.dart';

import '../core/services/app_APIs.dart';

final productProvider = Provider<ProductRepositories>((ref) {
  return ProductRepositories();
});

class ProductRepositories {
  ProductRepositories();

  baseapiservice apiservice = networkapiservice();

  Future<ProductModel> addProduct(Map<String, dynamic> data, String id, List<File>? images,) async
  {
    try {
      dynamic response = await apiservice.PostApiWithMultiport(AppApis.AddProductEndPoints.replaceFirst(':id', id), data, images,);
      return ProductModel.fromJson(response);
    } catch (e) {
      print("Error:${e}");
      throw e;
    }
  }

  Future<List<ProductModel>> getProduct(String Category) async {
    List<ProductModel> productlist = [];
    try {
      dynamic response = await apiservice.GetApiResponce(AppApis.GetProductsEndPoints.replaceFirst(':Category', Category));
      if (response is List) {
        return response.map((products) => ProductModel.fromJson(products as Map<String, dynamic>),).toList();
      }
      productlist = [ProductModel.fromJson(response)];
      return productlist;
    } catch (e) {
      throw e;
    }
  }

  Future<List<ProductModel>> searchProduct(String subCategory) async {
    List<ProductModel> productlist = [];
    try {
      dynamic response = await apiservice.GetApiResponce(AppApis.GetProductBySubCategoryEndPoints.replaceFirst(':name', subCategory));
      if (response is List) {
        return response.map((products) => ProductModel.fromJson(products as Map<String, dynamic>),).toList();
      }
      productlist = [ProductModel.fromJson(response)];
      return productlist;
    } catch (e) {
      throw e;
    }
  }

  Future<ProductModel> FindProduct(String id) async {
    try {
      dynamic response = await apiservice.GetApiResponce(
        AppApis.GetProductByIDEndPoints.replaceFirst(':id', id),
      );
      print('Responce: ${response}');
      ProductModel productlist = ProductModel.fromJson(response);
      return productlist;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ProductModel>> getUserProduct(String id) async {
    List<ProductModel> productlist = [];
    try {
      dynamic response = await apiservice.GetApiResponce(
        AppApis.GetUserProductsEndPoints.replaceFirst(':id', id),
      );
      if (response is List) {
        return response
            .map(
              (products) =>
                  ProductModel.fromJson(products as Map<String, dynamic>),
            )
            .toList();
      }
      productlist = [ProductModel.fromJson(response)];
      return productlist;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ProductModel>> getShopProduct(String id) async {
    List<ProductModel> productlist = [];
    try {
      dynamic response = await apiservice.GetApiResponce(
        AppApis.GetShopProductsEndPoints.replaceFirst(':id', id),
      );
      if (response is List) {
        return response
            .map(
              (products) =>
                  ProductModel.fromJson(products as Map<String, dynamic>),
            )
            .toList();
      }
      productlist = [ProductModel.fromJson(response)];
      return productlist;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateProduct(
    Map<String, dynamic> data,
    String id,
    List<File>? images,
  ) async
  {
    try {
      dynamic response = await apiservice.UpdateApiWithMultiport(
        AppApis.UpdateProductEndPoints.replaceFirst(':id', id),
        data,
        images,
      );
      if (kDebugMode) {
        print(response);
      }
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //from product detail view
  Future<dynamic> deleteProduct(String id) async {
    try {
      dynamic response = await apiservice.DeleteApiResponce(
        AppApis.DeleteProductEndPoints.replaceFirst(':id', id),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
