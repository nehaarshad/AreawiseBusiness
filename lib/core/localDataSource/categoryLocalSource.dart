import 'package:ecommercefrontend/models/SubCategoryModel.dart';
import 'package:ecommercefrontend/models/categoryModel.dart';
import 'package:ecommercefrontend/models/hiveModels/categoryHiveModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../models/mappers/categoryMapper.dart';

final categoryLocalDataSourceProvider = Provider<categoryLocalDataSource>((ref) {
  final dataSource = categoryLocalDataSource();
  dataSource.init();
  return dataSource;

});

class categoryLocalDataSource {
  static const String allCategoriesBox = 'all_categories_cache';

  late Box<CategoryHiveModel> _categoryBox;

  Future<void> init() async {
    _categoryBox = await Hive.openBox<CategoryHiveModel>(allCategoriesBox);
     }

  Future<void> cacheAllCategories(List<Category> category) async {
    // Clear old cache
    await _categoryBox.clear();

    try{
      // Save all ads
      for (var catg in category) {
        if (catg.id != null) {
          ///convert to hive model for storage
          final hiveModel = CategoryMapper.toHiveModel(catg);
          await _categoryBox.put(catg.id, hiveModel);  // Use ad ID as key
        }
      }
    }catch(e){
      throw e;
    }
  }

  List<Category> getAllCategories() {
    return _categoryBox.values
        .map((hive) => CategoryMapper.fromHiveModel(hive))
        .toList();
  }

  List<Subcategory>? getSubcategoriesOfCategories(String categoryName) {
    try {
      // Find the category by name
      final categoryHive = _categoryBox.values.firstWhere(
            (cat) => cat.name?.toLowerCase() == categoryName.toLowerCase(),
        orElse: () => CategoryHiveModel(), // Return empty model if not found
      );

      // If category found and has subcategories, convert and return them
      if (categoryHive.id != null && categoryHive.subcategories != null) {
        return categoryHive.subcategories!
            .map((subHive) => Subcategory(
          id: subHive.id,
          name: subHive.name,
        ))
            .toList();
      }

      // Return empty list if no subcategories found
      return [];
    } catch (e) {
      print('Error fetching subcategories from cache: $e');
      return null;
    }
  }

  bool hasCachedData() {
    return _categoryBox.isNotEmpty;
  }


}