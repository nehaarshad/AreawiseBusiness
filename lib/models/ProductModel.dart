import 'dart:io';

import 'SubCategoryModel.dart';
import 'categoryModel.dart';

class ProductModel {
  int? id;
  String? name;
  int? price;
  String? description;
  int? stock;
  int? seller;
  int? shopid;
  int? categoryId;
  int? subcategoryId;
  String? createdAt;
  String? updatedAt;
  List<ProductImages>? images;
  Category? category;
  Subcategory? subcategory;

  ProductModel({
    this.id,
    this.name,
    this.price,
    this.description,
    this.stock,
    this.seller,
    this.shopid,
    this.categoryId,
    this.subcategoryId,
    this.createdAt,
    this.updatedAt,
    this.images,
    this.category,
    this.subcategory,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    description = json['description'];
    stock = json['stock'];
    seller = json['seller'];
    shopid = json['shopid'];
    categoryId = json['categoryId'];
    subcategoryId = json['subcategoryId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['Images'] != null) {
      images = <ProductImages>[];
      json['Images'].forEach((v) {
        images!.add(new ProductImages.fromJson(v));
      });
    }
    category =
        json['category'] != null
            ? new Category.fromJson(json['category'])
            : null;
    subcategory =
        json['subcategory'] != null
            ? new Subcategory.fromJson(json['subcategory'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['description'] = this.description;
    data['stock'] = this.stock;
    data['seller'] = this.seller;
    data['shopid'] = this.shopid;
    data['categoryId'] = this.categoryId;
    data['subcategoryId'] = this.subcategoryId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.images != null) {
      data['Images'] = this.images!.map((v) => v.toJson()).toList();
    }
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.subcategory != null) {
      data['subcategory'] = this.subcategory!.toJson();
    }
    return data;
  }

  ProductModel copyWith({
    int? id,
    String? name,
    int? price,
    String? description,
    int? stock,
    int? seller,
    int? shopid,
    int? categoryId,
    int? subcategoryId,
    String? createdAt,
    String? updatedAt,
    List<ProductImages>? images,
    Category? category,
    Subcategory? subcategory,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      stock: stock ?? this.stock,
      seller: seller ?? this.seller,
      shopid: shopid ?? this.shopid,
      categoryId: categoryId ?? this.categoryId,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      images: images ?? this.images,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
    );
  }
}

class ProductImages {
  int? id;
  String? imagetype;
  int? entityId;
  Null? imageData;
  File? file;
  String? imageUrl;
  String? createdAt;
  String? updatedAt;

  ProductImages({
    this.id,
    this.imagetype,
    this.entityId,
    this.imageData,
    this.imageUrl,
    this.file,
    this.createdAt,
    this.updatedAt,
  });

  ProductImages.fromJson(Map<String, dynamic> json) {
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

  String toString() {
    return 'Images(id: $id, imagetype: $imagetype, imageUrl: $imageUrl)';
  }
}
