import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../View_Model/adminViewModels/AdViewModel.dart';
import '../../core/utils/colors.dart';
import '../shared/widgets/loadingState.dart';

class UserAdsView extends ConsumerStatefulWidget {
  final String sellerId;
  const UserAdsView({Key? key, required this.sellerId}) : super(key: key);

  @override
  ConsumerState<UserAdsView> createState() => _UserAdsViewState();
}

class _UserAdsViewState extends ConsumerState<UserAdsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(AdsViewModelProvider.notifier).getAllAds();
    });
  }

  @override
  Widget build(BuildContext context) {
    final adsState = ref.watch(AdsViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Active Ads",style: TextStyle(color:Appcolors.baseColor,fontWeight: FontWeight.bold,fontSize: 20.sp),),

      ),
      backgroundColor: Appcolors.whiteSmoke,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Consumer(builder: (context, ref, child) {
              return adsState.when(
                loading: () => const Column(
                  children: [
                    ShimmerListTile(),
                    ShimmerListTile(),
                    ShimmerListTile(),
                    ShimmerListTile(),
                  ],
                ),
                data: (ads) {
                  if (ads.isEmpty) {
                    return Center(child: Text("No Active Ads Available"));
                  }

                  return ListView.builder(
                    itemCount: ads.length,
                    itemBuilder: (context, index) {
                      final ad = ads[index];
                      return Card(
                        margin:  EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                        elevation: 2,
                        child: Stack(
                          children: [
                            // Ad image
                            Container(
                              height: 200.h, // Set a fixed height or adjust as needed
                              width: double.infinity, // Ensure it takes the full width
                              child: ad?.image != null && ad?.image!.imageUrl != null
                                  ? CachedNetworkImage(
                               imageUrl:  ad!.image!.imageUrl!,
                                fit: BoxFit.fill,
                                width: double.infinity,
                                errorWidget: (context, error, stackTrace) {
                                  return Center(child: Icon(Icons.error));
                                },
                              )
                                  : Container(
                                color: Colors.grey[300],
                                child:  Center(child: Icon(Icons.image_not_supported, size: 50.h)),
                              ),
                            ),
                            // Delete icon positioned at the top-right corner
                            Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  if (ad?.id != null) {
                                    await ref.read(AdsViewModelProvider.notifier).deleteAds(ad!.id.toString(), widget.sellerId);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                error: (error, stackTrace) => Center(child: Text('Error: ${error.toString()}')),
              );
            }),

      ),
    );
  }
}