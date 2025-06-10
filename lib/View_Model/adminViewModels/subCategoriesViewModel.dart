import 'dart:async';
import 'package:ecommercefrontend/models/SubCategoryModel.dart';
import 'package:ecommercefrontend/models/categoryModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import '../../models/UserDetailModel.dart';
import '../../repositories/UserDetailsRepositories.dart';
import '../../repositories/categoriesRepository.dart';
import '../SharedViewModels/getAllCategories.dart';

final subCategoryViewModelProvider = StateNotifierProvider.family<subCategoryViewModel, AsyncValue<List<Subcategory?>>,String>((
    ref,name
    ) {
  return subCategoryViewModel(ref,name);
});

class subCategoryViewModel extends StateNotifier<AsyncValue<List<Subcategory?>>> {
  final Ref ref;
  String name;
  subCategoryViewModel(this.ref,this.name) : super(AsyncValue.loading()) {
    getSubcategories();
  }

  Future<void> getSubcategories() async {
    try {
      List<Subcategory> subcategories = await ref.read(categoryProvider).FindSubCategories(name);
      state = AsyncValue.data(subcategories);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      print('Error loading subcategories: $e');
    }
  }

  Future<void> deleteSubcategory(String id) async {
    try {
      await ref.read(categoryProvider).deleteSubcategory(id);
      getSubcategories();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> addSubcategory(String name,int id) async {
    try {
      await ref.read(categoryProvider).addSubcategory(name, id);
      getSubcategories();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

}
