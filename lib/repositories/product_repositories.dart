import 'dart:convert';
import 'dart:io';

import 'package:ecommercefrontend/models/NewArrivalDuration.dart';
import 'package:ecommercefrontend/models/ProductModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommercefrontend/core/network/baseapiservice.dart';
import 'package:ecommercefrontend/core/network/networkapiservice.dart';
import 'package:riverpod/riverpod.dart';

import '../View_Model/auth/sessionmanagementViewModel.dart';
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

    Future<List<ProductModel>> getProduct(String Category) async {
      List<ProductModel> productlist = [];
      try {
        dynamic response = await apiservice.GetApiResponce(
            AppApis.GetProductsEndPoints.replaceFirst(':Category', Category),
            headers());
        if (response is List) {
          return response.map((products) =>
              ProductModel.fromJson(products as Map<String, dynamic>),)
              .toList();
        }
        productlist = [ProductModel.fromJson(response)];
        return productlist;
      } catch (e) {
        throw e;
      }
    }

  Future<ProductModel> getProductByID(String id) async {
    ProductModel product;
    try {
      dynamic response = await apiservice.GetApiResponce(
          AppApis.GetProductByIDEndPoints.replaceFirst(':id', id),
          headers());
     print("Get Product By id in repository ${response}");
      product = ProductModel.fromJson(response);
      return product;
    } catch (e) {
      throw e;
    }
  }

    Future<List<ProductModel>> getNewArrivalProduct(String Category) async {
      List<ProductModel> productlist = [];
      try {
        dynamic response = await apiservice.GetApiResponce(
            AppApis.getNewArrivalProductsEndPoints.replaceFirst(
                ':Category', Category), headers());
        if (response is List) {
          return response.map((products) =>
              ProductModel.fromJson(products as Map<String, dynamic>),)
              .toList();
        }
        productlist = [ProductModel.fromJson(response)];
        return productlist;
      } catch (e) {
        throw e;
      }
    }

  Future<List<ProductModel>> getOnSaleProducts(String Category) async {
    List<ProductModel> productlist = [];
    try {
      dynamic response = await apiservice.GetApiResponce(
          AppApis.getOnSaleProductsEndPoints.replaceFirst(
              ':Category', Category), headers());
      if (response is List) {
        return response.map((products) =>
            ProductModel.fromJson(products as Map<String, dynamic>),)
            .toList();
      }
      productlist = [ProductModel.fromJson(response)];
      return productlist;
    } catch (e) {
      throw e;
    }
  }

  Future<List<ProductModel>> getUserOnSaleProducts(String id) async {
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
      throw e;
    }
  }

  Future<List<ProductModel?>> getProductsBySubcategory(String subcategory) async {
    List<ProductModel> productlist = [];
    try {
      dynamic response = await apiservice.GetApiResponce(
          AppApis.GetProductBySubcategoryEndPoints.replaceFirst(
              ':subcategory', subcategory), headers());

      if (response is List) {
        return response.map((products) =>
            ProductModel.fromJson(products as Map<String, dynamic>),)
            .toList();
      }
      productlist = [ProductModel.fromJson(response)];
      return productlist;
    } catch (e) {
      throw e;
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
      List<ProductModel> productlist = [];
      try {
        dynamic response = await apiservice.GetApiResponce(
            AppApis.getProductByNameEndPoints.replaceFirst(':name', name),
            headers());
        if (response is List) {
          return response.map((products) =>
              ProductModel.fromJson(products as Map<String, dynamic>),)
              .toList();
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
            AppApis.GetProductByIDEndPoints.replaceFirst(':id', id), headers()
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
            AppApis.GetUserProductsEndPoints.replaceFirst(':id', id), headers()
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
            AppApis.GetShopProductsEndPoints.replaceFirst(':id', id), headers()
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

    Future<Map<String, dynamic>> updateProduct(Map<String, dynamic> data,
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
        return response;
      } catch (e) {
        rethrow;
      }
    }

    //from product detail view
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
