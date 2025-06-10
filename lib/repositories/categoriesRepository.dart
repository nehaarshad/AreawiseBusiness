import 'dart:convert';

import 'package:ecommercefrontend/models/categoryModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommercefrontend/core/network/baseapiservice.dart';
import 'package:ecommercefrontend/core/network/networkapiservice.dart';
import 'package:riverpod/riverpod.dart';

import '../core/services/app_APIs.dart';
import '../models/SubCategoryModel.dart';

final categoryProvider = Provider<CategoriesRepositories>((ref) {
  return CategoriesRepositories();
});

class CategoriesRepositories {
  CategoriesRepositories();

  baseapiservice apiservice = networkapiservice();

  Future<List<Category>> getCategories() async {
    List<Category> categories = [];
    try {
      dynamic response = await apiservice.GetApiResponce(
        AppApis.getCategoriesEndPoints,
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

  Future<List<Subcategory>> FindSubCategories(String category) async {
    List<Subcategory> Subcategorylist = [];
    try {
      dynamic response = await apiservice.GetApiResponce(
        AppApis.getSubcategoriesOfCategoryEndPoints.replaceFirst(
          ':categories',
          category,
        ),
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

  Future<Category> addCategory(String name)async{
    try {
      final data = jsonEncode({'name': name});
      final headers = {'Content-Type': 'application/json'};
      dynamic response = await apiservice.PostApiWithJson(AppApis.addCategoryEndPoints, data,headers);
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
      final headers = {'Content-Type': 'application/json'};
      dynamic response = await apiservice.PostApiWithJson(AppApis.addSubcategoryEndPoints, data,headers);
      return Category.fromJson(response);
    } catch (e) {
      throw e;
    }
  }

  Future <void> deleteCategory(String id)async{
    try {
      dynamic response = await apiservice.DeleteApiResponce(AppApis.deleteCategoryEndPoints.replaceFirst(':id', id));
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future <void> deleteSubcategory(String id)async{
    try {
      dynamic response = await apiservice.DeleteApiResponce(AppApis.deleteSubcategoryEndPoints.replaceFirst(':id', id));
      return response;
    } catch (e) {
      throw e;
    }
  }

}
