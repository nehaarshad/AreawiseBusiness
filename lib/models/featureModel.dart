import 'ProductModel.dart';

class featureModel {
  int? id;
  dynamic productID;
  int? userID;
  String? status;
  String? expireAt;
  String? createdAt;
  String? updatedAt;
  ProductModel? product;

  featureModel(
      {this.id,
        this.productID,
        this.userID,
        this.status,
        this.expireAt,
        this.createdAt,
        this.updatedAt,
        this.product});

  featureModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productID = json['productID'];
    userID = json['userID'];
    status = json['status'];
    expireAt = json['expire_at'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    product =
    json['product'] != null ? new ProductModel.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['productID'] = this.productID;
    data['userID'] = this.userID;
    data['status'] = this.status;
    data['expire_at'] = this.expireAt;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    return data;
  }
}
