import 'package:ecommercefrontend/models/hiveModels/ImageHiveModel.dart';
import 'package:ecommercefrontend/models/hiveModels/shopHiveModel.dart';
import 'package:ecommercefrontend/models/mappers/UserMapper.dart';
import 'package:ecommercefrontend/models/mappers/categoryMapper.dart';
import 'package:ecommercefrontend/models/shopModel.dart';

class ShopMapper{

  static ShopHiveModel toHiveModel(ShopModel shop){
    return ShopHiveModel(
      id: shop.id,
      shopname: shop.shopname,
      shopaddress: shop.shopaddress,
      sector: shop.sector,
      status: shop.status,
      city: shop.city,
      deliveryPrice: shop.deliveryPrice,
      userId: shop.userId,
      user: shop.user != null ? UserMapper.toHiveModel(shop.user!) : null,
      category: shop.category != null ? CategoryMapper.toHiveModel(shop.category!) : null,
      images: shop.images != null ? shop.images!.map((img)=> ImageHiveModel(imageUrl: img.imageUrl)).toList() : null,
      updatedAt: shop.updatedAt,
      createdAt: shop.createdAt
    );
  }

  static ShopModel fromHiveModel(ShopHiveModel? shop){
    return ShopModel(
        id: shop?.id ?? 0,
        shopname: shop?.shopname ?? "",
        shopaddress: shop?.shopaddress ?? "",
        sector: shop?.sector ?? "",
        status: shop?.status ?? "",
        city: shop?.city ?? "",
        deliveryPrice: shop?.deliveryPrice ?? 0,
        userId: shop?.userId ?? 0,
        user: shop?.user != null ? UserMapper.fromHiveModel(shop!.user!) : null,
        category: shop?.category != null ? CategoryMapper.fromHiveModel(shop!.category!) : null,
        images: shop?.images != null ? shop?.images!.map((img)=> ShopImages(imageUrl: img.imageUrl)).toList() : null,
        updatedAt: shop?.updatedAt ?? '',
        createdAt: shop?.createdAt ?? ''
    );
  }
}