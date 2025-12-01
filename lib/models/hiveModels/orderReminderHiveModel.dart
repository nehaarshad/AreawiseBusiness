import 'package:hive/hive.dart';
part 'orderReminderHiveModel.g.dart';

@HiveType(typeId: 8)
class OrderReminderHiveModel extends HiveObject {

  @HiveField(0)
  int? id;

  @HiveField(1)
  int? sellerOrderId;

  @HiveField(2)
  int? sellerId;

  @HiveField(3)
  int? orderId;

  @HiveField(4)
  bool? status;

  @HiveField(5)
  String? reminderDateTime;

  @HiveField(6)
  String? createdAt;

  @HiveField(7)
  String? updatedAt;

  OrderReminderHiveModel({
    this.id,
    this.sellerOrderId,
    this.sellerId,
    this.orderId,
    this.status,
    this.reminderDateTime,
    this.createdAt,
    this.updatedAt,
  });
}