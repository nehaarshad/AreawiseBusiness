import 'package:ecommercefrontend/models/cartModel.dart';
import 'package:ecommercefrontend/models/hiveModels/cartHiveModel.dart';
import 'package:ecommercefrontend/models/mappers/UserMapper.dart';
import 'cartItemMappers.dart';

class cartMapper{

  static CartHiveModel toHiveModel(Cart cart){
    return CartHiveModel(
      id: cart.id,
      createdAt: cart.createdAt,
      cartItems: cart.cartItems != null ? cart.cartItems?.map((c)=> ItemsMappers.toHiveModel(c)).toList() : null,
      status: cart.status,
      updatedAt: cart.updatedAt,
      user: cart.user !=null ? UserMapper.toHiveModel(cart.user!) : null,
      userId: cart.userId,

    );

  }

  static Cart fromHiveModel(CartHiveModel cart){
    return Cart(
      id: cart.id,
      createdAt: cart.createdAt,
      cartItems: cart.cartItems != null ? cart.cartItems?.map((c)=> ItemsMappers.fromHiveModel(c)).toList() : null,
      status: cart.status,
      updatedAt: cart.updatedAt,
      user: cart.user !=null ? UserMapper.fromHiveModel(cart.user!) : null,
      userId: cart.userId,

    );

  }
}