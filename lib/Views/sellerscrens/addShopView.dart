import 'dart:io';
import 'package:ecommercefrontend/View_Model/SellerViewModels/addShopViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../core/utils/utils.dart';
import '../shared/widgets/ShopCategoryDropDownMenu.dart';
import '../../core/utils/colors.dart';

class addShopView extends ConsumerStatefulWidget {
  int id;
  addShopView({required this.id});

  @override
  ConsumerState<addShopView> createState() => _addShopViewState();
}

class _addShopViewState extends ConsumerState<addShopView> {
  late final AddShopViewModel _viewModel;
  final formkey = GlobalKey<FormState>();
  final TextEditingController shopname = TextEditingController();
  final TextEditingController shopaddress = TextEditingController();
  final TextEditingController sector = TextEditingController();
  final TextEditingController city = TextEditingController();


  @override
  void dispose() {
    super.dispose();
    _viewModel.resetState();
    shopname.dispose();
    sector.dispose();
    shopaddress.dispose();
    city.dispose();

  }
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addShopProvider(widget.id.toString()));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appcolors.whiteColor,
          automaticallyImplyLeading:false,
        actions: [ Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                ref
                    .read(addShopProvider(widget.id.toString()).notifier)
                    .pickImages(context);
              },
              child: Text("Upload Images"),
            ),
          ],
        ),],
      ),
      backgroundColor: Appcolors.whiteColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                SizedBox(height: 20.h),
                if (state.images.isNotEmpty) ...[
                  if (state.images.length > 4)
                    Utils.flushBarErrorMessage("Select only 4 images", context),
                  SizedBox(
                    height: 100.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.images.length,

                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.file(state.images[index]),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: IconButton(
                                icon: Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  ref
                                      .read(
                                        addShopProvider(
                                          widget.id.toString(),
                                        ).notifier,
                                      )
                                      .removeImage(index);
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],

                TextFormField(
                  controller: shopname,
                  decoration: InputDecoration(labelText: "Shop Name"),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a Shop name";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: shopaddress,
                  decoration: InputDecoration(labelText: "Shop Address"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter address";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: sector,
                  decoration: InputDecoration(labelText: "Sector"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter Sector";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: city,
                  decoration: InputDecoration(labelText: "city"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter city";
                    }
                    return null;
                  },
                ),
                ShopcategoryDropdown(userid: widget.id.toString()),
                SizedBox(height: 20.h),
                InkWell(
                  onTap:state.isLoading
                      ? null
                      : () async {
                    if (formkey.currentState!.validate()) {
                      await ref
                          .read(
                        addShopProvider(
                          widget.id.toString(),
                        ).notifier,
                      )
                          .addShop(
                          shopname: shopname.text.trim(),
                          shopaddress: shopaddress.text.trim(),
                          sector: sector.text.trim(),
                          city: city.text.trim(),
                          userId:widget.id,
                          context: context
                      );
                    }
                  },
                  child: Container(
                    height: 40.h,
                    margin: EdgeInsets.symmetric(horizontal: 25.w),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Appcolors.blueColor,
                      borderRadius: BorderRadius.circular(15.r),

                    ),
                    child: Center(
                      child:state.isLoading
                          ? CircularProgressIndicator(color: Appcolors.whiteColor,)
                          : Text(
                        "Add Shop",
                        style: TextStyle(
                          color: Appcolors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5.h),
                // ElevatedButton(
                //   onPressed:
                //       state.isLoading
                //           ? null
                //           : () async {
                //             if (formkey.currentState!.validate()) {
                //               await ref
                //                   .read(
                //                     addShopProvider(
                //                       widget.id.toString(),
                //                     ).notifier,
                //                   )
                //                   .addShop(
                //                     shopname: shopname.text.trim(),
                //                     shopaddress: shopaddress.text.trim(),
                //                     sector: sector.text.trim(),
                //                     city: city.text.trim(),
                //                 userId:widget.id,
                //                 context: context
                //                   );
                //             }
                //           },
                //   child:
                //       state.isLoading
                //           ? Center(
                //             child: CircularProgressIndicator(
                //               color: Appcolors.blueColor,
                //             ),
                //           )
                //           : const Text('Add Shop'),
                // ),
                InkWell(
    onTap:()async{
    await ref.read(addShopProvider(widget.id.toString()).notifier).Cancel(widget.id.toString(),context);
    },
    child: Container(
    height: 40.h,
    margin: EdgeInsets.symmetric(horizontal: 25.w),
    width: double.infinity,
    decoration: BoxDecoration(
    color: Appcolors.whiteColor,
    borderRadius: BorderRadius.circular(15.r),
    border: Border.all(  // Use Border.all instead of boxShadow for borders
    color: Appcolors.blueColor,
    width: 1.0,  // Don't forget to specify border width
    ),
    ),
    child: Center(
    child: Text(
    "Cancel",
    style: TextStyle(
    color: Appcolors.blueColor,
    fontWeight: FontWeight.bold,
    fontSize: 15.sp,
    ),
    ),
    ),
    ),
    )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
