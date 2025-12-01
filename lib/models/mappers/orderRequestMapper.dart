import 'package:ecommercefrontend/models/hiveModels/orderRequestHiveModel.dart';
import 'package:ecommercefrontend/models/ordersRequestModel.dart';

import 'orderMapper.dart';
import 'orderReminderMapper.dart';

class OrderRequestMapper{

  static OrderRequestHiveModel toHiveModel(OrdersRequestModel order){

    return OrderRequestHiveModel(
      id: order.id,
      createdAt: order.createdAt,
      customerId: order.customerId,
      orderId: order.orderId,
      orderProductId: order.orderProductId,
      order: order.order != null ? OrderMapper.toHiveModel(order.order!) : null,
      orderReminder: order.orderReminder != null ? OrderReminderMapper.toHiveModel(order.orderReminder!) : null,
      sellerId: order.sellerId,
      status: order.status,
      total: order.total,
      updatedAt: order.updatedAt,

    );
  }

  static OrdersRequestModel fromHiveModel(OrderRequestHiveModel order){

    return OrdersRequestModel(
      id: order.id,
      createdAt: order.createdAt,
      customerId: order.customerId,
      orderId: order.orderId,
      orderProductId: order.orderProductId,
      order: order.order != null ? OrderMapper.fromHiveModel(order.order!) : null,
      orderReminder: order.orderReminder != null ? OrderReminderMapper.fromHiveModel(order.orderReminder!) : null,
      sellerId: order.sellerId,
      status: order.status,
      total: order.total,
      updatedAt: order.updatedAt,

    );
  }


}