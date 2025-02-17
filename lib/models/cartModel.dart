
import 'ProductModel.dart';

class cartModel {
  int? id;
  int? userId;
  String? status;
  String? createdAt;
  String? updatedAt;
  List<CartItems>? cartItems;

  cartModel(
      {this.id,
        this.userId,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.cartItems});

  cartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['UserId'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['CartItems'] != null) {
      cartItems = <CartItems>[];
      json['CartItems'].forEach((v) {
        cartItems!.add(new CartItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['UserId'] = this.userId;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.cartItems != null) {
      data['CartItems'] = this.cartItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CartItems {
  int? id;
  int? cartId;
  int? productId;
  int? quantity;
  int? price;
  String? createdAt;
  String? updatedAt;
  ProductModel? product;

  CartItems(
      {this.id,
        this.cartId,
        this.productId,
        this.quantity,
        this.price,
        this.createdAt,
        this.updatedAt,
        this.product});

  CartItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cartId = json['cartId'];
    productId = json['productId'];
    quantity = json['quantity'];
    price = json['price'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    product =
    json['product'] != null ? new ProductModel.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cartId'] = this.cartId;
    data['productId'] = this.productId;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    return data;
  }
}
