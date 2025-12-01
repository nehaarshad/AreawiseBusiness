import 'package:ecommercefrontend/models/hiveModels/ImageHiveModel.dart';
import 'package:ecommercefrontend/models/hiveModels/categoryHiveModel.dart';
import 'package:ecommercefrontend/models/hiveModels/userHiveModel.dart';
import 'package:hive/hive.dart';
part 'shopHiveModel.g.dart';

@HiveType(typeId: 11)
class ShopHiveModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? shopname;

  @HiveField(2)
  String? shopaddress;

  @HiveField(3)
  String? sector;

  @HiveField(4)
  String? city;

  @HiveField(5)
  int? categoryId;

  @HiveField(6)
  int? userId;

  @HiveField(7)
  int? deliveryPrice;

  @HiveField(8)
  String? status;

  @HiveField(9)
  String? createdAt;

  @HiveField(10)
  String? updatedAt;

  @HiveField(11)
  List<ImageHiveModel>? images;

  @HiveField(12)
  CategoryHiveModel? category;

  @HiveField(13)
  UserHiveModel? user;

  ShopHiveModel({
    this.id,
    this.shopname,
    this.shopaddress,
    this.sector,
    this.city,
    this.categoryId,
    this.userId,
    this.deliveryPrice,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.images,
    this.category,
    this.user,
  });
}