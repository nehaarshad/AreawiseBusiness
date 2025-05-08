import 'package:ecommercefrontend/models/categoryModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../repositories/categoriesRepository.dart';

final selectedCategoryProvider = StateProvider<String>((ref) => 'All');

final GetallcategoriesProvider = StateNotifierProvider<Getallcategories, AsyncValue<List<Category>>>((ref) {
  return Getallcategories(ref);
});

class Getallcategories extends StateNotifier<AsyncValue<List<Category>>> {
  final Ref ref;

  Getallcategories(this.ref) : super(AsyncValue.loading()) {
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

}
