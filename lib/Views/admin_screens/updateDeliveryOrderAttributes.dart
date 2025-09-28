import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:ecommercefrontend/core/utils/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../View_Model/adminViewModels/DeliveryOrderAttributesViewModel.dart';

class UpdateAttributes extends ConsumerStatefulWidget {
  const UpdateAttributes({super.key});

  @override
  ConsumerState<UpdateAttributes> createState() => _UpdateAttributesState();
}

class _UpdateAttributesState extends ConsumerState<UpdateAttributes> {

  void updateAttributes(attributesViewModel viewModel, BuildContext context) {

    final discountText = viewModel.discount.text;
    double? discount = double.tryParse(discountText);
    if (discount != null) {
      discount = discount / 100;  // Convert 25 to 0.25
    }

      final data = {
        'shippingPrice': 0,
        'discount': discount ?? 0.0,
        'totalBill': double.tryParse(viewModel.total.text)
      };

      viewModel.updateAttributes(data, context);

  }

  void updateDuration(attributesViewModel viewModel, BuildContext context) {

      final data = {
        'day': int.tryParse(viewModel.duration.text),
      };

      viewModel.updateDuration(data, context);

  }

  Widget formFields(attributesViewModel model) {
    print(model.discount);
    return Column(
      spacing: 10.h,
      children: [

        TextFormField(
          controller: model.discount,
          decoration:  InputDecoration(labelText: "Discount %",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0.r),
            ),

          ),

        ),

        TextFormField(
          controller: model.total,
          decoration:  InputDecoration(labelText: "Total",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0.r),
            ),),
        ),
      ],
    );
  }

  Widget DurationField(attributesViewModel model) {
    return TextFormField(
          controller: model.duration,
          decoration: InputDecoration(labelText: "Days",
          ),
        );


  }


  Widget UpdateButton(
      attributesViewModel viewModel,
      BuildContext context,
      ) {
    return Center(
      child:InkWell(
        onTap: (){ updateAttributes(viewModel, context);},
        child: Container(
          height: 25.h,
          width: 150.w,
          decoration: BoxDecoration(
            color: Appcolors.whiteSmoke,
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(  // Use Border.all instead of boxShadow for borders
              color: Appcolors.baseColor,
              width: 1.0,  // Don't forget to specify border width
            ),
          ),
          child: Center(
            child: Text(
              "Save changes",
              style: TextStyle(
                color: Appcolors.baseColor,
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final model = ref.read(attributesViewModelProvider.notifier);
    return Scaffold(
      appBar: AppBar(
         title: Text("Settings",style: AppTextStyles.headline,),
        backgroundColor: Appcolors.whiteSmoke,
      ),
      backgroundColor: Appcolors.whiteSmoke,
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h,),
                Text("Update New Arrivals Duration",style: AppTextStyles.body,),
                SizedBox(height: 10.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    model.duration !=null ? SizedBox(
                      width: 40,
                      child: DurationField(model),
                    ): CircularProgressIndicator(),
                    TextButton(onPressed: (){
                    updateDuration(model, context);
                    }, child: Text("Update"))
                  ],
                ),
                SizedBox(height: 30.h,),
                Text("Special discount offer:",style: AppTextStyles.body,),
                SizedBox(height: 10.h,),
                SizedBox(width: 200, child: formFields(model)),
                Padding(
                  padding:  EdgeInsets.only(top: 28.0.h),
                  child: UpdateButton( model, context),
                ),
              ],
            ),
          ),
      ),
    );
  }
}
