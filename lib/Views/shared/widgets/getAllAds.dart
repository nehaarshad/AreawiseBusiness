import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../View_Model/adminViewModels/AdViewModel.dart';
import '../../../core/utils/colors.dart';
import 'loadingState.dart';

class getAdsView extends ConsumerStatefulWidget {
  const getAdsView({Key? key,}) : super(key: key);

  @override
  ConsumerState<getAdsView> createState() => _getAdsViewState();
}

class _getAdsViewState extends ConsumerState<getAdsView> {

  final PageController page = PageController();
  int _currentPage = 0;
  Timer? timer;

  void startAutoScroll() {
    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      final adsState = ref.read(AdsViewModelProvider);
      if (adsState is AsyncData) {
        final ads = adsState.value;
        if (ads!.isNotEmpty) {
          if (_currentPage < ads.length - 1) {
            _currentPage++;
          } else {
            _currentPage = 0;
          }

          if (page.hasClients) {
            page.animateToPage(
              _currentPage,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(AdsViewModelProvider.notifier).getAllAds();
      startAutoScroll();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reset user list when coming back to this view
    Future.microtask(() async{
      await   ref.read(AdsViewModelProvider.notifier).getAllAds();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final adsState = ref.watch(AdsViewModelProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10),
      child: Container(
        height: 170.h,
        child: adsState.when(
          loading: () => const  ShimmerListTile(),

          data: (ads) {
            if (ads.isEmpty) {
              return Center(
                child: Center(child: Text("No Ads",style: TextStyle(fontWeight: FontWeight.bold,color: Appcolors.baseColor),)),
              );
            }
            return Stack(
              children: [
                PageView.builder(
                  controller: page,
                  itemCount: ads.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final ad = ads[index];
                    return ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                      child: Container(
                        height: 240.h,
                        width: double.infinity, // Ensure it takes the full width
                        child: ad?.image != null && ad?.image!.imageUrl != null
                            ? CachedNetworkImage(
                        imageUrl:   ad!.image!.imageUrl!,
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
                        );
                  },
                ),
              ],
            );
          },
          error: (error, stackTrace) => Center(
            child: Text('Error: ${error.toString()}'),
          ),
        ),
      ),
    );
  }
}