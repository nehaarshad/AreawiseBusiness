import 'dart:async';
import 'package:ecommercefrontend/models/SubCategoryModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import '../../repositories/categoriesRepository.dart';

final subCategoryViewModelProvider = StateNotifierProvider.family<subCategoryViewModel, AsyncValue<List<Subcategory?>>,String>((
    ref,name
    ) {
  return subCategoryViewModel(ref,name);
});

class subCategoryViewModel extends StateNotifier<AsyncValue<List<Subcategory?>>> {
  final Ref ref;
  String name;
  subCategoryViewModel(this.ref,this.name) : super(AsyncValue.loading()) {
    getSubcategories(name);
  }

  Future<void> getSubcategories(String name) async {
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
      getSubcategories(this.name);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> addSubcategory(String name,int id) async {
    try {
      await ref.read(categoryProvider).addSubcategory(name, id);
      getSubcategories(this.name);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

}
