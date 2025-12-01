import 'package:ecommercefrontend/models/hiveModels/productHiveModel.dart';
import 'package:ecommercefrontend/models/hiveModels/userHiveModel.dart';
import 'package:hive/hive.dart';
part 'featureHiveModel.g.dart';

@HiveType(typeId: 12)
class featureProductHiveModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  int? productID;

  @HiveField(2)
  int? userID;

  @HiveField(3)
  String? status;

  @HiveField(4)
  String? expireAt;

  @HiveField(5)
  ProductHiveModel? product;

  featureProductHiveModel({
    this.id,
    this.productID,
    this.userID,
    this.status,
    this.expireAt,
    this.product,
  });
}