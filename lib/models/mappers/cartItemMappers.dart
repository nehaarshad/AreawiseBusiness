import 'package:ecommercefrontend/models/cartItemModel.dart';
import 'package:ecommercefrontend/models/hiveModels/cartItemsHiveModel.dart';
import 'package:ecommercefrontend/models/mappers/productMapper.dart';

class ItemsMappers{

  static CartItemHiveModel toHiveModel(CartItems item){
    return CartItemHiveModel(
      id: item.id,
      cartId: item.cartId,
      createdAt: item.createdAt,
      price: item.price,
      productId: item.productId,
      product: item.product != null ? ProductMapper.toHiveModel(item.product!) : null,
      quantity: item.quantity,
      status: item.status,
      sellerId: item.sellerId,
      shippingPrice: item.shippingPrice,
      updatedAt: item.updatedAt,

    );
  }

  static CartItems fromHiveModel(CartItemHiveModel item){
    return CartItems(
      id: item.id,
      cartId: item.cartId,
      createdAt: item.createdAt,
      price: item.price,
      productId: item.productId,
      product: item.product != null ? ProductMapper.fromHiveModel(item.product!) : null,
      quantity: item.quantity,
      status: item.status,
      sellerId: item.sellerId,
      shippingPrice: item.shippingPrice,
      updatedAt: item.updatedAt,

    );
  }

}