import 'package:ecommercefrontend/models/hiveModels/cartHiveModel.dart';
import 'package:hive/hive.dart';
part 'orderHiveModel.g.dart';

@HiveType(typeId: 6)
class OrderHiveModel extends HiveObject {

  @HiveField(0)
  int? id;

  @HiveField(1)
  int? cartId;

  @HiveField(2)
  int? addressId;

  @HiveField(3)
  int? total;

  @HiveField(4)
  double? discount;

  @HiveField(5)
  int? discountAmount;

  @HiveField(6)
  int? shippingPrice;

  @HiveField(7)
  String? status;

  @HiveField(8)
  String? paymentMethod;

  @HiveField(9)
  String? paymentStatus;

  @HiveField(10)
  String? createdAt;

  @HiveField(11)
  String? updatedAt;

  @HiveField(12)
  CartHiveModel? cart;

  OrderHiveModel({
    this.id,
    this.cartId,
    this.addressId,
    this.total,
    this.discount,
    this.discountAmount,
    this.shippingPrice,
    this.status,
    this.paymentMethod,
    this.paymentStatus,
    this.createdAt,
    this.updatedAt,
    this.cart
  });
}
