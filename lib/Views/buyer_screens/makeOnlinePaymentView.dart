import 'package:ecommercefrontend/Views/shared/widgets/buttons.dart';
import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../View_Model/SharedViewModels/transcriptsViewModel.dart';

class makeOnlinePaymentView extends ConsumerStatefulWidget {
  final int orderId;
  final int sellerId;
  final String shop;
  const makeOnlinePaymentView({super.key,required this.orderId,required this.sellerId,required this.shop});

  @override
  ConsumerState<makeOnlinePaymentView> createState() => _makeOnlinePaymentViewState();
}

class _makeOnlinePaymentViewState extends ConsumerState<makeOnlinePaymentView> {


@override
  Widget build(BuildContext context) {
    final state=ref.watch(TranscriptsViewModelProvider);
    return  Scaffold(

      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Appcolors.whiteSmoke),
          onPressed: () {
            ref.read(TranscriptsViewModelProvider.notifier).resetState();
            Navigator.pop(context,false);
          },
        ),
        title: Text("Upload ${widget.shop} Transaction Slip",style: TextStyle(color: Appcolors.whiteSmoke,fontSize: 18.sp),),
        backgroundColor: Appcolors.baseColor,
      ),

      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  ref.read(TranscriptsViewModelProvider.notifier).pickImages(context);
                },
                child: Container(
                   width: 900.w,
                  height: 500.h,
                  decoration: BoxDecoration(
                    color: Appcolors.whiteSmoke
                  ),
                  margin: EdgeInsets.only(top: 10.h,bottom: 20.h),

                  child: state.adImage != null ? Image.file(state.adImage!, fit: BoxFit.contain,) : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.upload, size: 55.h, color: Appcolors.baseColorLight30),
                      SizedBox(height: 8),
                      Text("Tap to upload image", style: TextStyle(color: Appcolors.baseColor),),
                    ],
                  ),
                ),

              ),
              CustomButton(text: "Confirm", onPressed: (){
                ref.read(TranscriptsViewModelProvider.notifier).uploadTranscript(widget.sellerId, widget.orderId, context);
              })
            ],
      
      
      
          ),
        ),
    );
  }
}
