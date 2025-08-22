import 'dart:io';

import 'package:ecommercefrontend/models/reviewsModel.dart';
import 'package:ecommercefrontend/models/salesModel.dart';
import 'package:ecommercefrontend/models/shopModel.dart';

import 'SubCategoryModel.dart';
import 'categoryModel.dart';

class ProductModel {
  int? id;
  String? name;
  String? subtitle;
  int? price;
  String? condition;
  bool? onSale;
  String? description;
  int? stock;
  int? sold;
  int? ratings;
  int? seller;
  int? shopid;
  int? categoryId;
  int? subcategoryId;
  String? createdAt;
  String? updatedAt;
  List<ProductImages>? images;
  ShopModel? shop;
  Category? category;
  SaleOffer? saleOffer;
  Subcategory? subcategory;
  List<Reviews>? reviews;

  ProductModel(
      {this.id,
        this.name,
        this.subtitle,
        this.price,
        this.description,
        this.stock,
        this.condition,
        this.onSale,
        this.sold,
        this.saleOffer,
        this.ratings,
        this.seller,
        this.shopid,
        this.categoryId,
        this.subcategoryId,
        this.createdAt,
        this.updatedAt,
        this.images,
        this.shop,
        this.category,
        this.subcategory,
        this.reviews});

  ProductModel copyWith({
    int? id,
    String? name,
    String? subtitle,
    int? price,
    String? condition,
    bool? onSale,
    String? description,
    int? stock,
    int? sold,
    int? ratings,
    int? seller,
    int? shopid,
    SaleOffer? sale,
    int? categoryId,
    int? subcategoryId,
    String? createdAt,
    String? updatedAt,
    List<ProductImages>? images,
    ShopModel? shop,
    Category? category,
    Subcategory? subcategory,
    List<Reviews>? reviews,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      subtitle: subtitle ?? this.subtitle,
      price: price ?? this.price,
      description: description ?? this.description,
      condition: condition ?? this.condition,
      onSale: onSale ?? this.onSale,
      stock: stock ?? this.stock,
      sold: sold ?? this.sold,
      saleOffer:sale?? this.saleOffer,
      ratings: ratings ?? this.ratings,
      seller: seller ?? this.seller,
      shopid: shopid ?? this.shopid,
      categoryId: categoryId ?? this.categoryId,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      images: images ?? this.images,
      shop: shop ?? this.shop,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      reviews: reviews ?? this.reviews,
    );
  }

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    subtitle = json['subtitle'];
    price = json['price'];
    onSale = json['onSale'];
    condition = json['condition'];
    description = json['description'];
    stock = json['stock'];
    sold = json['sold'];
    ratings = json['ratings'];
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
    shop = json['shop'] != null ? new ShopModel.fromJson(json['shop']) : null;
    saleOffer = json['saleOffer'] != null
        ? new SaleOffer.fromJson(json['saleOffer'])
        : null;
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    subcategory = json['subcategory'] != null
        ? new Subcategory.fromJson(json['subcategory'])
        : null;
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(new Reviews.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['subtitle'] = this.subtitle;
    data['price'] = this.price;
    data['onSale'] = this.onSale;
    data['condition'] = this.condition;
    data['description'] = this.description;
    data['stock'] = this.stock;
    data['sold'] = this.sold;
    data['ratings'] = this.ratings;
    data['seller'] = this.seller;
    data['shopid'] = this.shopid;
    data['categoryId'] = this.categoryId;
    data['subcategoryId'] = this.subcategoryId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.images != null) {
      data['Images'] = this.images!.map((v) => v.toJson()).toList();
    }
    if (this.shop != null) {
      data['shop'] = this.shop!.toJson();
    }
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.subcategory != null) {
      data['subcategory'] = this.subcategory!.toJson();
    }
    if (this.saleOffer != null) {
      data['saleOffer'] = this.saleOffer!.toJson();
    }
    if (this.reviews != null) {
      data['reviews'] = this.reviews!.map((v) => v.toJson()).toList();
    }
    return data;
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

