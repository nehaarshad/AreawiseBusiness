
import 'package:ecommercefrontend/models/hiveModels/orderReminderHiveModel.dart';
import 'package:ecommercefrontend/models/orderReminderModel.dart';

class OrderReminderMapper{

  static OrderReminderHiveModel toHiveModel(OrderReminderModel order){
    return OrderReminderHiveModel(
      id: order.id,
      createdAt: order.createdAt,
      orderId: order.orderId,
      reminderDateTime: order.reminderDateTime,
      status: order.status,
      sellerId: order.sellerId,
      sellerOrderId: order.sellerOrderId,
      updatedAt: order.updatedAt,

    );
  }

  static OrderReminderModel fromHiveModel(OrderReminderHiveModel order){
    return OrderReminderModel(
      id: order.id,
      createdAt: order.createdAt,
      orderId: order.orderId,
      reminderDateTime: order.reminderDateTime,
      status: order.status,
      sellerId: order.sellerId,
      sellerOrderId: order.sellerOrderId,
      updatedAt: order.updatedAt,
    );
  }

}