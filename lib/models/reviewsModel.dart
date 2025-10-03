
import 'package:ecommercefrontend/models/imageModel.dart';

import 'ProductModel.dart';
import 'UserDetailModel.dart';

class Reviews {
  int? id;
  String? comment;
  int? rating;
  int? userId;
  int? productId;
  String? createdAt;
  String? updatedAt;
  ProductModel? product;
  List<ImageModel?>? images;
  UserDetailModel? user;

  Reviews(
      {this.id,
        this.comment,
        this.rating,
        this.userId,
        this.images,
        this.productId,
        this.createdAt,
        this.updatedAt,
        this.product,
        this.user});

  Reviews.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    rating = json['rating'];
    userId = json['userId'];
    if (json['Images'] != null) {
      images = <ImageModel>[];
      json['Images'].forEach((v) {
        images!.add(new ImageModel.fromJson(v));
      });
    }
    productId = json['productId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    product = json['product'] != null ? new ProductModel.fromJson(json['product']) : null;
    user = json['user'] != null ? new UserDetailModel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['comment'] = this.comment;
    data['rating'] = this.rating;
    data['userId'] = this.userId;
    data['productId'] = this.productId;
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

