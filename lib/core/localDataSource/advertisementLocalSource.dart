import 'package:ecommercefrontend/models/adsModel.dart';
import 'package:ecommercefrontend/models/hiveModels/adsHiveModel.dart';
import 'package:ecommercefrontend/models/mappers/adsMapper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final adsLocalDataSourceProvider = Provider<adsLocalDataSource>((ref) {

  final dataSource = adsLocalDataSource();
  dataSource.init();
  return dataSource;
});

class adsLocalDataSource {
  static const String allAdvertisementsBox = 'all_advertisement_cache';

  late Box<AdsHiveModel> _adsBox;

  Future<void> init() async {
    _adsBox = await Hive.openBox<AdsHiveModel>(allAdvertisementsBox);
  }

  Future<void> cacheAllAds(List<adsModel> advertisement) async {
    // Clear old cache
    await _adsBox.clear();
   print("Ads Cached");
    // Save all ads
    for (var ad in advertisement) {
      if (ad.id != null) {

        ///convert to hive model for storage
        final hiveModel = AdsMapper.toHiveModel(ad);
        await _adsBox.put(ad.id, hiveModel);  // Use ad ID as key
        print(_adsBox.get(ad.id));
      }
    }
  }

  List<adsModel> getAllAds() {
    return _adsBox.values
        .map((hive) => AdsMapper.fromHiveModel(hive))
        .toList();
  }

  bool hasCachedData() {
    return _adsBox.isNotEmpty;
  }


}