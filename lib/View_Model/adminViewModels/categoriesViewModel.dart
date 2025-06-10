import 'dart:async';
import 'package:ecommercefrontend/models/categoryModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import '../../models/UserDetailModel.dart';
import '../../repositories/UserDetailsRepositories.dart';
import '../../repositories/categoriesRepository.dart';
import '../SharedViewModels/getAllCategories.dart';

final categoryViewModelProvider = StateNotifierProvider<categoryViewModel, AsyncValue<List<Category?>>>((
    ref,
    ) {
  return categoryViewModel(ref);
});

class categoryViewModel extends StateNotifier<AsyncValue<List<Category?>>> {
  final Ref ref;
  categoryViewModel(this.ref) : super(AsyncValue.loading()) {
    getCategories();
  }

  Future<void> getCategories() async {
    try {
      List<Category> categories = await ref.read(categoryProvider).getCategories();
      state = AsyncValue.data(categories);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      print('Error loading categories: $e');
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      print('Category id sent to be deleted! ${id}');
      await ref.read(categoryProvider).deleteCategory(id);
      getCategories();
      ref.invalidate(GetallcategoriesProvider);
      await ref.read(GetallcategoriesProvider.notifier).getCategories();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> addCategory(String name) async {
    try {
      await ref.read(categoryProvider).addCategory(name);
      getCategories();
      ref.invalidate(GetallcategoriesProvider);
      await ref.read(GetallcategoriesProvider.notifier).getCategories();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }


}
