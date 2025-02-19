import 'cartItemModel.dart';

class Cart {
  int? id;
  int? userId;
  String? status;
  String? createdAt;
  String? updatedAt;
  List<CartItems>? cartItems;

  Cart({
    this.id,
    this.userId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.cartItems,
  });

  Cart.fromJson(Map<String, dynamic> json) {
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

