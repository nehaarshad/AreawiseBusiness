import 'package:ecommercefrontend/models/UserDetailModel.dart';

import 'ProductModel.dart';

class featureModel {
  int? id;
  int? productID;
  int? userID;
  String? status;
  String? expireAt;
  String? createdAt;
  String? updatedAt;
  ProductModel? product;
  UserDetailModel? user;

  featureModel(
      {this.id,
        this.productID,
        this.userID,
        this.status,
        this.expireAt,
        this.createdAt,
        this.updatedAt,
        this.product,
        this.user});

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
    user = json['user'] != null ? new UserDetailModel.fromJson(json['user']) : null;
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
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class Images {
  int? id;
  String? imagetype;
  Null userId;
  int? productId;
  Null shopId;
  Null adId;
  Null imageData;
  String? imageUrl;
  String? createdAt;
  String? updatedAt;

  Images(
      {this.id,
        this.imagetype,
        this.userId,
        this.productId,
        this.shopId,
        this.adId,
        this.imageData,
        this.imageUrl,
        this.createdAt,
        this.updatedAt});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imagetype = json['imagetype'];
    userId = json['UserId'];
    productId = json['ProductId'];
    shopId = json['ShopId'];
    adId = json['AdId'];
    imageData = json['imageData'];
    imageUrl = json['imageUrl'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['imagetype'] = this.imagetype;
    data['UserId'] = this.userId;
    data['ProductId'] = this.productId;
    data['ShopId'] = this.shopId;
    data['AdId'] = this.adId;
    data['imageData'] = this.imageData;
    data['imageUrl'] = this.imageUrl;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}



