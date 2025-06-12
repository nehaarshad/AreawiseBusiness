import 'package:ecommercefrontend/models/SubCategoryModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../repositories/categoriesRepository.dart';

final searchProductProvider = StateNotifierProvider<SearchProductViewModel, AsyncValue<List<Subcategory>>>((ref,) {
  return SearchProductViewModel(ref);
});

class SearchProductViewModel extends StateNotifier<AsyncValue<List<Subcategory>>> {
  final Ref ref;

  SearchProductViewModel(this.ref, ) : super(AsyncValue.loading()) {
    getSubcategories();
  }

  Future<List<Subcategory>> getSubcategories() async {
    try {
       List<Subcategory> subcategories = await ref.read(categoryProvider).getSubcategories();
      state =   AsyncValue.data(subcategories);
      return subcategories;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      print('Error loading categories: $e');
      return [];
    }
  }


  }

