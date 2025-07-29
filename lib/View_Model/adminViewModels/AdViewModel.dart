import 'package:ecommercefrontend/core/utils/utils.dart';
import 'package:ecommercefrontend/repositories/adRepository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/adsModel.dart';

final AdsViewModelProvider = StateNotifierProvider<AdsViewModel, AsyncValue<List<adsModel?>>>((ref,) {
  return AdsViewModel(ref);
});

class AdsViewModel extends StateNotifier<AsyncValue<List<adsModel?>>> {
  final Ref ref;
  AdsViewModel(this.ref) : super(AsyncValue.loading());

  ///for dashboardView
  Future<void> getAllAds() async {
    try {
      List<adsModel?> ads = await ref.read(adProvider).getAllAds();
      state = AsyncValue.data(ads.isEmpty ? [] : ads);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  ///delete ad by giving its ID..seller ID for refetch seller ads
  Future<void> deleteAds(String id,String userId) async {
    try {
      await ref.read(adProvider).deleteAd(id);
      Utils.toastMessage("Ad Removed!");
      await getAllAds();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}