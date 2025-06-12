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

class addProductView extends ConsumerStatefulWidget {
  ShopModel shop;
  addProductView({required this.shop});

  @override
  ConsumerState<addProductView> createState() => _addProductViewState();
}

class _addProductViewState extends ConsumerState<addProductView> {

  final formkey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController subtitle = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController stock = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String shopId=widget.shop.id.toString();
    print("shopID: ${shopId} with type: ${shopId.runtimeType}");
    final state = ref.watch(addProductProvider(shopId));
    return Scaffold(
      appBar: AppBar(title: Text("Add Product")),
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
                                  ref.read(addProductProvider(shopId).notifier).removeImage(index);
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ElevatedButton(
                  onPressed: () {
                    ref.read(addProductProvider(shopId).notifier).pickImages(context);
                  },
                  child: Text("Upload Images"),
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
                ProductCategoryDropdown(shopid: shopId),
                ProductSubcategoryDropdown(shopId:shopId),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: state.isLoading ? null : () async {
                            if (formkey.currentState!.validate()) {
                              await ref.read(addProductProvider(shopId).notifier,)
                                  .addProduct(
                                    name: name.text,
                                    price: price.text,
                                  subtitle:subtitle.text,
                                    description: description.text,
                                    stock: stock.text,
                                    user:widget.shop.userId.toString(),
                                    context: context,
                                  );
                            }
                          },
                  child: state.isLoading ? Center(
                            child: CircularProgressIndicator(
                              color: Appcolors.blueColor,
                            ),
                          ) : const Text('Add Product'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
