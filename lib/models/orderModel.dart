import 'cartModel.dart';

class orderModel {
  int? id;
  int? cartId;
  int? addressId;
  int? total;
  double? discount;
  int? discountAmount;
  int? shippingPrice;
  String? status;
  String? paymentMethod;
  String? paymentStatus;
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
        this.paymentMethod,
        this.discountAmount,
        this.paymentStatus,
        this.createdAt,
        this.updatedAt,
        this.cart});
  orderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? int.tryParse(json['id'].toString()) : null;
    cartId = json['cartId'] != null ? int.tryParse(json['cartId'].toString()) : null;
    addressId = json['addressId'] != null ? int.tryParse(json['addressId'].toString()) : null;
    total = json['total'] != null ? int.tryParse(json['total'].toString()) : null;
    discount = json['discount'] != null ? double.tryParse(json['discount'].toString()) : null;
    discountAmount = json['discountAmount'] != null ? int.tryParse(json['discountAmount'].toString()) : null;
    shippingPrice = json['shippingPrice'] != null ? int.tryParse(json['shippingPrice'].toString()) : null;
    status = json['status'];
    paymentStatus = json['paymentStatus'];
    paymentMethod = json['paymentMethod'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    cart = json['Cart'] != null ? Cart.fromJson(json['Cart']) : null;
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
    data['discountAmount'] = this.discountAmount;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.cart != null) {
      data['Cart'] = this.cart!.toJson();
    }
    return data;
  }
}


