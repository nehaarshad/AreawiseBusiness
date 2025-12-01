
import 'package:hive/hive.dart';
part 'ImageHiveModel.g.dart';
@HiveType(typeId: 1)
class ImageHiveModel extends HiveObject {
  @HiveField(0)
  String? imageUrl;

  ImageHiveModel({
    this.imageUrl,
  });
}