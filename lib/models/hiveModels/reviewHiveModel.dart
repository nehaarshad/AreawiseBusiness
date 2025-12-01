import 'package:ecommercefrontend/models/hiveModels/userHiveModel.dart';
import 'package:hive/hive.dart';
part 'reviewHiveModel.g.dart';

@HiveType(typeId: 10)
class ReviewHiveModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? comment;

  @HiveField(2)
  int? rating;

  @HiveField(3)
  int? userId;

  @HiveField(4)
  int? productId;

  @HiveField(5)
  String? createdAt;

  @HiveField(6)
  String? updatedAt;

  @HiveField(7)
  List<String>? imageUrls;

  @HiveField(8)
  String? userName;

  @HiveField(9)
  String? userImageUrl;

  @HiveField(10)
  UserHiveModel? user;

  ReviewHiveModel({
    this.id,
    this.comment,
    this.rating,
    this.userId,
    this.productId,
    this.createdAt,
    this.updatedAt,
    this.imageUrls,
    this.userName,
    this.userImageUrl,
    this.user
  });
}