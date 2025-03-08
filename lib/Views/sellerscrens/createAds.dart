import 'package:ecommercefrontend/View_Model/SellerViewModels/createAdViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../shared/widgets/SetDateTime.dart';

class createAds extends ConsumerStatefulWidget {
  final String SellerId;
  const createAds({required this.SellerId});

  @override
  ConsumerState<createAds> createState() => _createAdsState();
}

class _createAdsState extends ConsumerState<createAds> {
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
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ad.adImage != null ? Image.file(ad.adImage!, fit: BoxFit.cover,) : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.upload, size: 50, color: Colors.grey[600]),
                      SizedBox(height: 8),
                      Text("Tap to upload image", style: TextStyle(color: Colors.grey[600]),),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Date & Time Selection
              Text("Select Expiration Date & Time", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              GestureDetector(
                onTap: (){
                  createAds(context);
                  },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
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
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: ad.isLoading ? null : () {
                  ref.read(createAdsViewModelProvider.notifier).createAd(widget.SellerId, context);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                ),
                child: ad.isLoading ? CircularProgressIndicator(color: Colors.white)
                    : Text("Create Ad", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
