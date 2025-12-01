import 'package:ecommercefrontend/models/hiveModels/productHiveModel.dart';
import 'package:hive/hive.dart';
part 'cartItemsHiveModel.g.dart';

@HiveType(typeId: 5)
class CartItemHiveModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  int? cartId;

  @HiveField(2)
  int? productId;

  @HiveField(3)
  int? sellerId;

  @HiveField(4)
  int? shippingPrice;

  @HiveField(5)
  int? quantity;

  @HiveField(6)
  int? price;

  @HiveField(7)
  String? status;

  @HiveField(8)
  String? createdAt;

  @HiveField(9)
  String? updatedAt;

  @HiveField(10)
  ProductHiveModel? product;

  CartItemHiveModel({
    this.id,
    this.cartId,
    this.productId,
    this.sellerId,
    this.shippingPrice,
    this.quantity,
    this.price,
    this.product,
    this.updatedAt,
    this.createdAt,
    this.status
  });
}
