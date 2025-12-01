import 'package:ecommercefrontend/models/UserDetailModel.dart';
import 'package:ecommercefrontend/models/hiveModels/reviewHiveModel.dart';
import 'package:ecommercefrontend/models/hiveModels/userHiveModel.dart';
import 'package:ecommercefrontend/models/mappers/shopMapper.dart';
import 'package:ecommercefrontend/models/reviewsModel.dart';
import '../../models/ProductModel.dart';
import '../../models/SubCategoryModel.dart';
import '../../models/categoryModel.dart';
import '../../models/hiveModels/productHiveModel.dart';
import '../../models/salesModel.dart';
import '../../models/shopModel.dart';
import '../hiveModels/ImageHiveModel.dart';
import '../imageModel.dart';

class ProductMapper {
  //  ProductModel to HiveModel for storage
  static ProductHiveModel toHiveModel(ProductModel product) {
    return ProductHiveModel(
        id: product.id,
        name: product.name,
        subtitle: product.subtitle,
        price: product.price,
        condition: product.condition,
        onSale: product.onSale,
        description: product.description,
        stock: product.stock,
        sold: product.sold,
        ratings: product.ratings,
        seller: product.seller,
        views: product.views,
        onCartCounts: product.onCartCounts,
        shopid: product.shopid,
        categoryId: product.categoryId,
        subcategoryId: product.subcategoryId,
        createdAt: product.createdAt,
        updatedAt: product.updatedAt,
        categoryName: product.category?.name,
        subcategoryName: product.subcategory?.name,
        shopName: product.shop?.shopname,
        salePercentage: product.saleOffer?.discount,
        salePrice: product.saleOffer?.price,
        images: product.images?.map((img) => ImageHiveModel(
          imageUrl: img.imageUrl,
        )).toList(),
        rating: product.ratings,
        reviews: product.reviews?.map((review) => ReviewHiveModel(
          id: review.id,
          comment: review.comment,
          rating: review.rating,
          userId: review.userId,
          productId: review.productId,
          createdAt: review.createdAt,
          updatedAt: review.updatedAt,
          userName: review.user?.username,
          userImageUrl: review.user?.image?.imageUrl,
          user: review.user != null ? UserHiveModel(
            id: review.user!.id,
            username: review.user!.username,
            imageUrl: review.user!.image?.imageUrl,
          ) : null,
          imageUrls: review.images?.map((img) => img?.imageUrl).whereType<String>().toList(),
        )).toList() ?? [],
        shop: product.shop !=null ? ShopMapper.toHiveModel(product.shop!) : null
    );
  }

  static ProductModel fromHiveModel(ProductHiveModel hive) {
    return ProductModel(
      id: hive.id,
      name: hive.name,
      subtitle: hive.subtitle,
      price: hive.price,
      condition: hive.condition,
      onSale: hive.onSale,
      description: hive.description,
      stock: hive.stock,
      sold: hive.sold,
      views: hive.views,
      onCartCounts: hive.onCartCounts,
      ratings: hive.ratings,
      seller: hive.seller,
      shopid: hive.shopid,
      categoryId: hive.categoryId,
      subcategoryId: hive.subcategoryId,
      createdAt: hive.createdAt,
      updatedAt: hive.updatedAt,
      category: hive.categoryName != null
          ? Category(id: hive.categoryId, name: hive.categoryName)
          : null,
      subcategory: hive.subcategoryName != null
          ? Subcategory(id: hive.subcategoryId, name: hive.subcategoryName)
          : null,
      shop: hive.shop != null
          ? ShopMapper.fromHiveModel(hive.shop)
          : null,
      saleOffer: hive.salePercentage != null
          ? SaleOffer(discount: hive.salePercentage, price: hive.salePrice)
          : null,
      images: hive.images?.map((img) => ProductImages(
        imageUrl: img.imageUrl,
      )).toList(),
      reviews: hive.reviews?.map((review) => Reviews(
        id: review.id,
        comment: review.comment,
        rating: review.rating,
        userId: review.userId,
        productId: review.productId,
        createdAt: review.createdAt,
        updatedAt: review.updatedAt,
        images: review.imageUrls?.map((url) => ImageModel(imageUrl: url)).toList(),
        user: review.user != null
            ?
        UserDetailModel(
          id: review.user!.id,
          username: review.user!.username,
          image: review.user!.imageUrl != null
              ? ProfileImage(imageUrl: review.user!.imageUrl)
              : null,
        )
            :
        null,
      )).toList(),
    );
  }
}