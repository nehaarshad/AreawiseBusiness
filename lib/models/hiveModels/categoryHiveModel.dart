import 'package:ecommercefrontend/models/hiveModels/ImageHiveModel.dart';
import 'package:ecommercefrontend/models/hiveModels/subcategoryHiveModel.dart';
import 'package:hive/hive.dart';
part 'categoryHiveModel.g.dart';

@HiveType(typeId: 3)
class CategoryHiveModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  ImageHiveModel? image;

  @HiveField(3)
  List<SubcategoryHiveModel>? subcategories;

  CategoryHiveModel({
    this.id,
    this.name,
    this.image,
    this.subcategories
  });
}