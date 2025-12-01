import 'package:hive/hive.dart';
part 'subcategoryHiveModel.g.dart';

@HiveType(typeId: 7)
class SubcategoryHiveModel extends HiveObject {

  @HiveField(0)
  int? id;

  @HiveField(1)
  String? name;

  SubcategoryHiveModel({
    this.id,
    this.name,
  });

}
