import 'package:ecommercefrontend/models/hiveModels/userHiveModel.dart';
import 'package:hive/hive.dart';
import 'cartItemsHiveModel.dart';
part 'cartHiveModel.g.dart';

@HiveType(typeId: 4)
class CartHiveModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  int? userId;

  @HiveField(2)
  String? status;

  @HiveField(3)
  String? createdAt;

  @HiveField(4)
  String? updatedAt;

  @HiveField(5)
  List<CartItemHiveModel>? cartItems;

  @HiveField(6)
  UserHiveModel? user;

  CartHiveModel({
    this.id,
    this.userId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.cartItems,
  });
}
