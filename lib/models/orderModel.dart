import 'cartModel.dart';

class orderModel {
  int? id;
  int? cartId;
  int? addressId;
  int? total;
  double? discount;
  int? shippingPrice;
  String? status;
  String? createdAt;
  String? updatedAt;
  Cart? cart;

  orderModel(
      {this.id,
        this.cartId,
        this.addressId,
        this.total,
        this.discount,
        this.shippingPrice,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.cart});

  orderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cartId = json['cartId'];
    addressId = json['addressId'];
    total = json['total'];
    discount = json['discount'];
    shippingPrice = json['shippingPrice'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    cart = json['Cart'] != null ? new Cart.fromJson(json['Cart']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cartId'] = this.cartId;
    data['addressId'] = this.addressId;
    data['total'] = this.total;
    data['discount'] = this.discount;
    data['shippingPrice'] = this.shippingPrice;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.cart != null) {
      data['Cart'] = this.cart!.toJson();
    }
    return data;
  }
}




