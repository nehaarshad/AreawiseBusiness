import 'package:ecommercefrontend/Views/sellerscrens/widgets/shopsDropDown.dart';
import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../View_Model/SellerViewModels/uploadExcelSheetViewModel.dart';
import '../shared/widgets/buttons.dart';


class UploadExcelSheetView extends ConsumerStatefulWidget {
  final String userid;
  const UploadExcelSheetView({super.key,required this.userid});

  @override
  ConsumerState<UploadExcelSheetView> createState() => _UploadExcelSheetViewState();
}

class _UploadExcelSheetViewState extends ConsumerState<UploadExcelSheetView> {


  @override
  Widget build(BuildContext context) {


    final state = ref.watch(uploadExcelSheetProvider(widget.userid));

    return  Scaffold(
      backgroundColor: Appcolors.baseWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: (){
              ref.read(uploadExcelSheetProvider(widget.userid).notifier).resetState();
             Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back,color: Appcolors.whiteSmoke,)),
        backgroundColor: Appcolors.baseColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w,vertical: 50.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 50.h,
                  children: [
        
                        InkWell(
                          onTap: () {
                            ref.read(uploadExcelSheetProvider(widget.userid).notifier).pickFile(context);
        
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8.0.r),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.upload, size: 50.h, color: Colors.grey[600]),
                                    SizedBox(height: 8),
                                    Text("Tap to upload Excel Sheet", style: TextStyle(color: Colors.grey[600]),),
                                  ],
                                ),
                                height: 200.h,
                                width: 400.w,
                                //  width: 250.w,
                              ),
                              if(state.uploadedFile != null)
                                Text("${state.uploadedFile}",style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Appcolors.baseColor,
                                  decorationStyle: TextDecorationStyle.solid,
                                overflow: TextOverflow.ellipsis),
                                ),
                            ],
                          ),
                        ),
        
        
                    if(state.uploadedFile != null)
                    ActiveUserShopDropdown(userid:widget.userid),
                    SizedBox(height: 20.h,),
                    Consumer(
                      builder: (context, ref, child) {
                        return CustomButton(
                          text: "Upload",
                          onPressed: () {
                            ref.read(uploadExcelSheetProvider(widget.userid).notifier).uploadProduct( context: context);
        
                          },
                          isLoading: false,
                        );
                      },
                    ),
                        ],
                      ),
              ),
      ),
      );
  }
}
