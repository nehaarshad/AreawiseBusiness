import 'package:ecommercefrontend/models/featureModel.dart';
import 'package:ecommercefrontend/models/hiveModels/featureHiveModel.dart';
import 'package:ecommercefrontend/models/mappers/UserMapper.dart';
import 'package:ecommercefrontend/models/mappers/productMapper.dart';

class FeatureProductMapper {
  // ProductModel to HiveModel for storage
  static featureProductHiveModel toHiveModel(featureModel featureProduct) {
    return featureProductHiveModel(
      id: featureProduct.id,
      productID: featureProduct.productID,
      userID: featureProduct.userID,
      status: featureProduct.status,
      expireAt: featureProduct.expireAt,
      product: featureProduct.product != null
          ? ProductMapper.toHiveModel(featureProduct.product!)
          : null,
    );
  }

  // HiveModel back to ProductModel for UI
  static featureModel fromHiveModel(featureProductHiveModel featureProduct) {
    return featureModel(
      id: featureProduct.id,
      productID: featureProduct.productID,
      userID: featureProduct.userID,
      status: featureProduct.status,
      expireAt: featureProduct.expireAt,
      product: featureProduct.product != null
          ? ProductMapper.fromHiveModel(featureProduct.product!)
          : null,
    );
  }
}