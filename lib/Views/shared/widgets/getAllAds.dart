import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../View_Model/SharedViewModels/AdViewModel.dart';
import '../../../core/utils/routes/routes_names.dart';
import 'colors.dart';

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
  void dispose() {
    timer?.cancel();
    page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final adsState = ref.watch(AdsViewModelProvider);
    return Container(
      height: 200,
      child: adsState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Appcolors.blueColor),
        ),
        data: (ads) {
          if (ads.isEmpty) {
            return Center(
              child: Center(child: Text("No Featured Ads",style: TextStyle(fontWeight: FontWeight.bold,color: Appcolors.blueColor),)),
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
                        borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 240,
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
                      );
                },
              ),
              // Positioned(
              //   bottom: 10,
              //   left: 0,
              //   right: 0,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: List.generate(
              //       ads.length,
              //           (index) => Container(
              //         width: 8,
              //         height: 8,
              //         margin: const EdgeInsets.symmetric(horizontal: 4),
              //         decoration: BoxDecoration(
              //           shape: BoxShape.circle,
              //           color: _currentPage == index
              //               ? Appcolors.blueColor
              //               : Colors.grey.shade500,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          );
        },
        error: (error, stackTrace) => Center(
          child: Text('Error: ${error.toString()}'),
        ),
      ),
    );
  }
}