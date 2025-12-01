import '../adsModel.dart';
import '../hiveModels/ImageHiveModel.dart';
import '../hiveModels/adsHiveModel.dart';

class AdsMapper {
  static AdsHiveModel toHiveModel(adsModel ads) {
    return AdsHiveModel(
      id: ads.id,
      image: ads.image != null
          ? ImageHiveModel(imageUrl: ads.image!.imageUrl!)
          : null,
    );
  }

  static adsModel fromHiveModel(AdsHiveModel ads) {
    return adsModel(
      id: ads.id,
      image: ads.image != null
          ? Image(imageUrl: ads.image!.imageUrl!)
          : null,
    );
  }
}