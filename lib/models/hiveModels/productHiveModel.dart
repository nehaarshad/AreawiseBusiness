import 'package:ecommercefrontend/models/hiveModels/reviewHiveModel.dart';
import 'package:ecommercefrontend/models/hiveModels/shopHiveModel.dart';
import 'package:hive/hive.dart';
import 'ImageHiveModel.dart';
part 'productHiveModel.g.dart';

@HiveType(typeId: 0)
class ProductHiveModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? subtitle;

  @HiveField(3)
  int? price;

  @HiveField(4)
  String? condition;

  @HiveField(5)
  bool? onSale;

  @HiveField(6)
  String? description;

  @HiveField(7)
  int? stock;

  @HiveField(8)
  int? sold;

  @HiveField(9)
  int? ratings;

  @HiveField(10)
  int? seller;

  @HiveField(11)
  int? shopid;

  @HiveField(12)
  int? categoryId;

  @HiveField(13)
  int? subcategoryId;

  @HiveField(14)
  String? createdAt;

  @HiveField(15)
  String? updatedAt;

  @HiveField(16)
  List<ImageHiveModel>? images;

  @HiveField(17)
  String? categoryName;

  @HiveField(18)
  String? subcategoryName;

  @HiveField(19)
  String? shopName;

  @HiveField(20)
  int? salePercentage;

  @HiveField(21)
  int? salePrice;

  @HiveField(22)
  int? rating;

  @HiveField(23)
  List<ReviewHiveModel>? reviews;

  @HiveField(24)
  ShopHiveModel? shop;

  @HiveField(25)
  int? views;

  @HiveField(26)
  int? onCartCounts;

  ProductHiveModel({
    this.id,
    this.name,
    this.subtitle,
    this.price,
    this.condition,
    this.onSale,
    this.description,
    this.stock,
    this.sold,
    this.ratings,
    this.seller,
    this.shopid,
    this.categoryId,
    this.subcategoryId,
    this.createdAt,
    this.updatedAt,
    this.images,
    this.categoryName,
    this.subcategoryName,
    this.shopName,
    this.salePercentage,
    this.salePrice,
    this.reviews,
    this.rating,
    this.shop,
    this.views,
    this.onCartCounts
  });
}
