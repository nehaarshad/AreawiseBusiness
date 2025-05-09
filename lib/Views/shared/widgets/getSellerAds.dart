import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../View_Model/SharedViewModels/AdViewModel.dart';
import '../../../core/utils/routes/routes_names.dart';
import 'colors.dart';

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
      ref.read(AdsViewModelProvider.notifier).getUserAds(widget.sellerId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final adsState = ref.watch(AdsViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Active Ads",style: TextStyle(color:Appcolors.blueColor,fontWeight: FontWeight.bold,fontSize: 20),),

      ),
      backgroundColor: Appcolors.whiteColor,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Consumer(builder: (context, ref, child) {
              return adsState.when(
                loading: () => const Center(child: CircularProgressIndicator(color: Appcolors.blueColor)),
                data: (ads) {
                  if (ads.isEmpty) {
                    return Center(child: Text("No Active Ads Available"));
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: ads.length,
                    itemBuilder: (context, index) {
                      final ad = ads[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        elevation: 2,
                        child: Stack(
                          children: [
                            // Ad image
                            Container(
                              height: 200, // Set a fixed height or adjust as needed
                              width: double.infinity, // Ensure it takes the full width
                              child: ad?.image != null && ad?.image!.imageUrl != null
                                  ? Image.network(
                                ad!.image!.imageUrl!,
                                fit: BoxFit.fill,
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(child: Icon(Icons.error));
                                },
                              )
                                  : Container(
                                color: Colors.grey[300],
                                child: const Center(child: Icon(Icons.image_not_supported, size: 50)),
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