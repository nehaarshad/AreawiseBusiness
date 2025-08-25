import 'ProductModel.dart';

class CartItems {
  int? id;
  int? cartId;
  int? productId;
  int? sellerId;
  int? shippingPrice;
  int? quantity;
  int? price;
  String? status;
  String? createdAt;
  String? updatedAt;
  ProductModel? product;

  CartItems({
    this.id,
    this.cartId,
    this.productId,
    this.quantity,
    this.price,
    this.sellerId,
    this.shippingPrice,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.product,
  });

  CartItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cartId = json['cartId'];
    productId = json['productId'];
    shippingPrice = json['shippingPrice'];
    sellerId = json['sellerId'];
    quantity = json['quantity'];
    price = json['price'];
    status=json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    product =
    json['product'] != null
        ? new ProductModel.fromJson(json['product'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cartId'] = this.cartId;
    data['productId'] = this.productId;
    data['quantity'] = this.quantity;
    data['shippingPrice']=this.shippingPrice;
    data['sellerId']=this.sellerId;
    data['price'] = this.price;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    return data;
  }
}
