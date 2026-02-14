import 'package:ecommercefrontend/models/SubCategoryModel.dart';
import 'package:ecommercefrontend/models/categoryModel.dart';
import 'package:ecommercefrontend/models/hiveModels/subcategoryHiveModel.dart';
import '../hiveModels/ImageHiveModel.dart';
import '../hiveModels/categoryHiveModel.dart';

class CategoryMapper{

  static CategoryHiveModel toHiveModel(Category category){
       print("category id in mapper ${category.id.runtimeType}");
    return CategoryHiveModel(
        id: category.id,
        name: category.name,
        status: category.status,
        image: category.image !=null ? ImageHiveModel(imageUrl: category.image!.imageUrl!) : null,
        subcategories: category.subcategories !=null ? category.subcategories?.map((sub)=>SubcategoryHiveModel(id: sub.id,name: sub.name)).toList() : null
    );

  }

  static Category fromHiveModel(CategoryHiveModel category){

    return Category(
      id: category.id,
       name: category.name,
      status: category.status,
      image: category.image !=null ? catImage(imageUrl: category.image!.imageUrl) : null,
      subcategories: category.subcategories !=null ? category.subcategories?.map((sub)=>Subcategory(id: sub.id,name: sub.name)).toList() : null
    );

  }


}