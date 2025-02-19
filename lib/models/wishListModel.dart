import 'package:ecommercefrontend/models/ProductModel.dart';

class wishListModel {
  int? id;
  int? userId;
  int? productId;
  String? createdAt;
  String? updatedAt;
  ProductModel? product;

  wishListModel(
      {this.id,
        this.userId,
        this.productId,
        this.createdAt,
        this.updatedAt,
        this.product});

  wishListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    productId = json['productId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    product =
    json['product'] != null ? new ProductModel.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['productId'] = this.productId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    return data;
  }
}
