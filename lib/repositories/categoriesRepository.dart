import 'dart:convert';
import 'dart:io';

import 'package:ecommercefrontend/models/categoryModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommercefrontend/core/network/baseapiservice.dart';
import 'package:ecommercefrontend/core/network/networkapiservice.dart';
import 'package:riverpod/riverpod.dart';

import '../View_Model/auth/sessionmanagementViewModel.dart';
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
    print("incategory token $token");
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
  baseapiservice apiservice = networkapiservice();

  Future<List<Category>> getCategories() async {
    List<Category> categories = [];
    try {
      dynamic response = await apiservice.GetApiResponce(
        AppApis.getCategoriesEndPoints, headers(),
      );
      if (response is List) {
        return response
            .map(
              (category) => Category.fromJson(category as Map<String, dynamic>),
            )
            .toList();
      }
      categories = [Category.fromJson(response)];
      return categories;
    } catch (e) {
      throw e;
    }
  }

  Future<List<Subcategory>> getSubcategories() async {
    List<Subcategory> categories = [];
    try {

      dynamic response = await apiservice.GetApiResponce(
        AppApis.getAllsubcategoriesEndPoints, headers(),
      );
      if (response is List) {
        return response
            .map(
              (category) => Subcategory.fromJson(category as Map<String, dynamic>),
        )
            .toList();
      }
      categories = [Subcategory.fromJson(response)];
      return categories;
    } catch (e) {
      throw e;
    }
  }

  Future<List<Subcategory>> FindSubCategories(String category) async {
    List<Subcategory> Subcategorylist = [];
    try {

      dynamic response = await apiservice.GetApiResponce(
        AppApis.getSubcategoriesOfCategoryEndPoints.replaceFirst(
          ':categories',
          category,
        ), headers(),
      );
      if (response is List) {
        return response
            .map(
              (subcategories) =>
                  Subcategory.fromJson(subcategories as Map<String, dynamic>),
            )
            .toList();
      }
      Subcategorylist = [Subcategory.fromJson(response)];
      return Subcategorylist;
    } catch (e) {
      throw e;
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
