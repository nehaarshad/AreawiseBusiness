import 'package:ecommercefrontend/View_Model/SellerViewModels/createAdViewModel.dart';
import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/utils/routes/routes_names.dart';
import '../shared/widgets/SetDateTime.dart';

class createAds extends ConsumerStatefulWidget {
  final String SellerId;
  const createAds({required this.SellerId});

  @override
  ConsumerState<createAds> createState() => _createAdsState();
}

class _createAdsState extends ConsumerState<createAds> {



  late final createAdsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ref.read(createAdsViewModelProvider.notifier);
  }

  @override
  void dispose() {
    // Reset the state when the widget is disposed
    _viewModel.resetState();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = ref.watch(createAdsViewModelProvider);
    final key = GlobalKey<FormState>();

    Future<void> createAds(BuildContext context) async {
      final DateTime? selectedDateTime = await setDateTime(context);
      if (selectedDateTime != null) {
        ref.read(createAdsViewModelProvider.notifier).selectExpirationDateTime(selectedDateTime);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Create Ad"),
        actions: [
          TextButton(
              onPressed: (){
                Navigator.pushNamed(
                  context,
                  routesName.activeADS,
                  arguments: widget.SellerId,
                );
          }, child: Text("Active ADs"))
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Upload Section
              GestureDetector(
                onTap: () {
                  ref.read(createAdsViewModelProvider.notifier).pickImages(context);
                },
                child: Container(
                  height: 200.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0.r),
                  ),
                  child: ad.adImage != null ? Image.file(ad.adImage!, fit: BoxFit.cover,) : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.upload, size: 50.h, color: Colors.grey[600]),
                      SizedBox(height: 8),
                      Text("Tap to upload image", style: TextStyle(color: Colors.grey[600]),),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // Date & Time Selection
              Text("Select Expiration Date & Time", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 8.h),
              GestureDetector(
                onTap: (){
                  createAds(context);
                  },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(ad.expirationDateTime != null ? "${ad.expirationDateTime!.day}/${ad.expirationDateTime!.month}/${ad.expirationDateTime!.year} at ${ad.expirationDateTime!.hour}:${ad.expirationDateTime!.minute.toString().padLeft(2, '0')}"
                            : "Select Date and Time"),
                      Icon(Icons.calendar_today, color: Colors.blue),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32.h),
              ElevatedButton(
                onPressed: ad.isLoading ? null : () {
                  ref.read(createAdsViewModelProvider.notifier).createAd(widget.SellerId, context);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  backgroundColor: Colors.blue,
                ),
                child: ad.isLoading ? CircularProgressIndicator(color: Appcolors.whiteColor, )
                    : Text("Create Ad", style: TextStyle(fontSize: 16.sp,color: Appcolors.whiteColor, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
