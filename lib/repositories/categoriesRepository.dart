import 'dart:convert';
import 'dart:io';

import 'package:ecommercefrontend/models/categoryModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommercefrontend/core/network/baseapiservice.dart';
import 'package:ecommercefrontend/core/network/networkapiservice.dart';
import 'package:riverpod/riverpod.dart';

import '../View_Model/auth/sessionmanagementViewModel.dart';
import '../core/localDataSource/categoryLocalSource.dart';
import '../core/network/appexception.dart';
import '../core/network/networkChecker.dart';
import '../core/services/app_APIs.dart';
import '../models/SubCategoryModel.dart';

final categoryProvider = Provider<CategoriesRepositories>((ref) {
  return CategoriesRepositories(ref: ref);
});

class CategoriesRepositories {
  Ref ref;
  CategoriesRepositories({required this.ref});

  Map<String, String> headers() {
    final token = ref.read(sessionProvider)?.token;
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  baseapiservice apiservice = networkapiservice();

  categoryLocalDataSource get localDataSource => ref.read(categoryLocalDataSourceProvider);

  NetworkChecker get networkChecker => ref.read(networkCheckerProvider);

  Future<List<Category>> fetchAndCacheAllCategories() async {

      if (localDataSource.hasCachedData()) {
        return localDataSource.getAllCategories();
      }
      return [];

  }

  Future<List<Category>> getCategories() async {
    final isConnected = await networkChecker.isConnected();

    if (isConnected) {
        List<Category> categories = [];
        try {
          dynamic response = await apiservice.GetApiResponce(
            AppApis.getCategoriesEndPoints, headers(),
          );

          List<Category> categories = (response as List)
              .map((category) => Category.fromJson(category as Map<String, dynamic>))
              .toList();

          await localDataSource.cacheAllCategories(categories);
          return categories;
        } catch (e) {
          print(e);
            return localDataSource.getAllCategories();

        }
    }
    else{
      if(localDataSource.hasCachedData())
        {
          return localDataSource.getAllCategories();
        }
      throw NoInternetException("No internet and no cache data");
    }
  }

  Future<List<Subcategory>> getSubcategories() async {

    try {

      dynamic response = await apiservice.GetApiResponce(
        AppApis.getAllsubcategoriesEndPoints, headers(),
      );
      List<Subcategory> categories= (response as List)
          .map((category) => Subcategory.fromJson(category as Map<String, dynamic>))
          .toList();

      return categories;
    } catch (e) {
      throw e;
    }
  }

  Future<List<Subcategory>> FindSubCategories(String category) async {
    final isConnected = await networkChecker.isConnected();

    if (isConnected) {
      try {
        dynamic response = await apiservice.GetApiResponce(
          AppApis.getSubcategoriesOfCategoryEndPoints.replaceFirst(
            ':categories',
            category,
          ),
          headers(),
        );
        return (response as List)
            .map((subcategories) => Subcategory.fromJson(subcategories as Map<String, dynamic>))
            .toList();

      } catch (e) {
        print('Error finding subcategories: $e');
        if (localDataSource.hasCachedData()) {
          final cachedSubcategories = localDataSource.getSubcategoriesOfCategories(category);
          if (cachedSubcategories != null && cachedSubcategories.isNotEmpty) {
            return cachedSubcategories;
          }
        }
        throw NoInternetException("No internet and no data available");
      }
    } else {
      if (localDataSource.hasCachedData()) {
        final cachedSubcategories = localDataSource.getSubcategoriesOfCategories(category);
        if (cachedSubcategories != null && cachedSubcategories.isNotEmpty) {
          return cachedSubcategories;
        }
      }
      throw NoInternetException("No internet and no data available");
    }
  }

  Future<Category> addCategory(String name, File? image,)async{
    try {
      final data = {'name': name};

      dynamic response = await apiservice.SingleFileUploadApiWithMultiport(AppApis.addCategoryEndPoints, data,image, headers(),);
      return Category.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  Future<Category> updateCategory(String id,String name,String status, File? image,)async{
    try {
      final data = {'name': name, 'status': status};

      dynamic response = await apiservice.SingleFileUpdateApiWithMultiport(AppApis.updateCategoryEndPoints.replaceFirst(':id', id), data,image, headers(),);
      print(response);
      return Category.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  Future<Category> addSubcategory(String name,int id)async{
    try {
      final data = jsonEncode({
        'name': name,
         'categoryId':id
      });

      dynamic response = await apiservice.PostApiWithJson(AppApis.addSubcategoryEndPoints, data, headers(),);
      return Category.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  Future <void> deleteCategory(String id)async{
    try {

      dynamic response = await apiservice.DeleteApiResponce(AppApis.deleteCategoryEndPoints.replaceFirst(':id', id), headers(),);
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future <void> deleteSubcategory(String id)async{
    try {

      dynamic response = await apiservice.DeleteApiResponce(AppApis.deleteSubcategoryEndPoints.replaceFirst(':id', id), headers(),);
      return response;
    } catch (e) {
      throw e;
    }
  }

}
