import 'package:hive/hive.dart';
import 'ImageHiveModel.dart';
part 'adsHiveModel.g.dart';

@HiveType(typeId: 2)
class AdsHiveModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  ImageHiveModel? image;

  AdsHiveModel({
    this.id,
    this.image,
  });
}