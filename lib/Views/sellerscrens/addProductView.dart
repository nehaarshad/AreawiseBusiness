import 'dart:io';
import 'package:ecommercefrontend/View_Model/SellerViewModels/addProductViewModel.dart';
import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:ecommercefrontend/core/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ecommercefrontend/models/shopModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../View_Model/SellerViewModels/ProductStates.dart';
import '../shared/widgets/ProductCateASubCategoryDropdownMenu.dart';
import '../shared/widgets/ShopCategoryDropDownMenu.dart';
import '../shared/widgets/shopsDropDown.dart';

class addProductView extends ConsumerStatefulWidget {
  String userId;
  addProductView({required this.userId});

  @override
  ConsumerState<addProductView> createState() => _addProductViewState();
}

class _addProductViewState extends ConsumerState<addProductView> {

  late final AddProductViewModel _viewModel;
  final formkey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController subtitle = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController stock = TextEditingController();


  @override
  void dispose() {
    super.dispose();
    _viewModel.resetState();
    name.dispose();
    subtitle.dispose();
    description.dispose();
    price.dispose();
    stock.dispose();

  }

  @override
  Widget build(BuildContext context) {
    String userid=widget.userId.toString();
    print("userid: ${userid} with type: ${userid.runtimeType}");
    final state = ref.watch(addProductProvider(userid));
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading:false,
          backgroundColor: Appcolors.whiteColor,
          actions: [  Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  ref.read(addProductProvider(userid).notifier).pickImages(context);
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
                if (state.images.isNotEmpty)
                  SizedBox(
                    height: 120.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.images.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 100.w, // Define explicit width
                                height: 100.h, // Define explicit height
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: Image.file(
                                    state.images[index],
                                    fit: BoxFit.cover, // Important for proper display
                                  ),
                                ),
                              ),
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
                                  ref.read(addProductProvider(userid).notifier).removeImage(index);
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                TextFormField(
                  controller: name,
                  decoration: InputDecoration(labelText: "Product Name"),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a product name";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: price,
                  decoration: InputDecoration(labelText: "Price"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a price";
                    }
                    return null;
                  },
                ),
                TextFormField(
                    controller: subtitle,
                    decoration: InputDecoration(labelText: "Subtitle"),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Provide subtitle of a product";
                      }
                      return null;
                    },
                ),
                TextFormField(
                  controller: description,
                  decoration: InputDecoration(labelText: "Description"),
                  maxLines: 3,
                  maxLength: 150,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a description";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: stock,
                  decoration: InputDecoration(labelText: "Stock"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter stock quantity";
                    }
                    return null;
                  },
                ),
                ProductCategoryDropdown(shopid: userid),
                ProductSubcategoryDropdown(userId:userid),
                ActiveUserShopDropdown(userid:userid),
                SizedBox(height: 20),
                InkWell(
                  onTap:state.isLoading ? null : () async {
                    if (formkey.currentState!.validate()) {
                      await ref.read(addProductProvider(userid).notifier,)
                          .addProduct(
                        name: name.text,
                        price: price.text,
                        subtitle:subtitle.text,
                        description: description.text,
                        stock: stock.text,
                        user:widget.userId.toString(),
                        context: context,
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
                      child: Text(
                        "Add Product",
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
                InkWell(
                  onTap:()async{
                    await ref.read(addProductProvider(widget.userId.toString()).notifier).Cancel(widget.userId.toString(),context);
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
