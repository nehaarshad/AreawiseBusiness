import 'package:ecommercefrontend/models/hiveModels/orderReminderHiveModel.dart';
import 'package:hive/hive.dart';

import 'orderHiveModel.dart';
part 'orderRequestHiveModel.g.dart';

@HiveType(typeId: 9)
class OrderRequestHiveModel extends HiveObject {

  @HiveField(0)
  int? id;

  @HiveField(1)
  int? sellerId;

  @HiveField(2)
  int? customerId;

  @HiveField(3)
  double? total;

  @HiveField(4)
  int? orderId;

  @HiveField(5)
  int? orderProductId;

  @HiveField(6)
  String? status;

  @HiveField(7)
  String? createdAt;

  @HiveField(8)
  String? updatedAt;

  @HiveField(9)
  OrderHiveModel? order;

  @HiveField(10)
  OrderReminderHiveModel? orderReminder;


  OrderRequestHiveModel({
    this.id,
    this.sellerId,
    this.customerId,
    this.total,
    this.orderId,
    this.orderProductId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.orderReminder,
    this.order
  });

}