
import 'package:ecommercefrontend/models/hiveModels/orderHiveModel.dart';
import 'package:ecommercefrontend/models/orderModel.dart';

import 'cartMappers.dart';

class OrderMapper{

  static OrderHiveModel toHiveModel(orderModel order){
    return OrderHiveModel(
      id: order.id,
      addressId: order.addressId,
      createdAt: order.createdAt,
      cartId: order.cartId,
      cart: order.cart !=null ? cartMapper.toHiveModel(order.cart!) : null,
      discount: order.discount,
      discountAmount: order.discountAmount,
      paymentMethod: order.paymentMethod,
      paymentStatus: order.paymentStatus,
      status: order.status,
      shippingPrice: order.shippingPrice,
      total: order.total,
      updatedAt: order.updatedAt,
    );
  }

  static orderModel fromHiveModel(OrderHiveModel order){
    return orderModel(
      id: order.id,
      addressId: order.addressId,
      createdAt: order.createdAt,
      cartId: order.cartId,
      cart: order.cart !=null ? cartMapper.fromHiveModel(order.cart!) : null,
      discount: order.discount,
      discountAmount: order.discountAmount,
      paymentMethod: order.paymentMethod,
      paymentStatus: order.paymentStatus,
      status: order.status,
      shippingPrice: order.shippingPrice,
      total: order.total,
      updatedAt: order.updatedAt,
    );
  }

}