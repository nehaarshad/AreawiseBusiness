import 'dart:io';

import 'categoryModel.dart';

class ShopModel {
  int? id;
  String? shopname;
  String? shopaddress;
  String? sector;
  String? city;
  int? categoryId;
  int? userId;
  String? createdAt;
  String? updatedAt;
  List<ShopImages>? images;
  Category? category;

  ShopModel({
    this.id,
    this.shopname,
    this.shopaddress,
    this.sector,
    this.city,
    this.categoryId,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.images,
    this.category,
  });

  ShopModel copyWith({
    int? id,
    String? shopname,
    String? shopaddress,
    String? sector,
    String? city,
    int? categoryId,
    int? userId,
    String? createdAt,
    String? updatedAt,
    Category? category,
    List<ShopImages>? images,
  }) {
    return ShopModel(
      id: id ?? this.id,
      shopname: shopname ?? this.shopname,
      shopaddress: shopaddress ?? this.shopaddress,
      sector: sector ?? this.sector,
      city: city ?? this.city,
      categoryId: categoryId ?? this.categoryId,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      category: category ?? this.category,
      images: images ?? this.images,
    );
  }

  ShopModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shopname = json['shopname'];
    shopaddress = json['shopaddress'];
    sector = json['sector'];
    city = json['city'];
    categoryId = json['categoryId'];
    userId = json['userId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['Images'] != null) {
      images = <ShopImages>[];
      json['Images'].forEach((v) {
        images!.add(new ShopImages.fromJson(v));
      });
    }
    category =
        json['category'] != null
            ? new Category.fromJson(json['category'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['shopname'] = this.shopname;
    data['shopaddress'] = this.shopaddress;
    data['sector'] = this.sector;
    data['city'] = this.city;
    data['categoryId'] = this.categoryId;
    data['userId'] = this.userId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.images != null) {
      data['Images'] = this.images!.map((v) => v.toJson()).toList();
    }
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    return data;
  }
}

class ShopImages {
  int? id;
  String? imagetype;
  int? entityId;
  Null? imageData;
  String? imageUrl;
  String? createdAt;
  String? updatedAt;
  File? file;

  ShopImages({
    this.id,
    this.imagetype,
    this.entityId,
    this.imageData,
    this.imageUrl,
    this.file,
    this.createdAt,
    this.updatedAt,
  });

  ShopImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imagetype = json['imagetype'];
    entityId = json['entityId'];
    imageData = json['imageData'];
    imageUrl = json['imageUrl'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['imagetype'] = this.imagetype;
    data['entityId'] = this.entityId;
    data['imageData'] = this.imageData;
    data['imageUrl'] = this.imageUrl;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
