import 'dart:io';
import 'package:ecommercefrontend/View_Model/SellerViewModels/addProductViewModel.dart';
import 'package:ecommercefrontend/View_Model/SellerViewModels/updateProductViewModel.dart';
import 'package:ecommercefrontend/Views/shared/Screens/ProductDetailView.dart';
import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:ecommercefrontend/core/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ecommercefrontend/models/shopModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../models/ProductModel.dart';
import '../shared/widgets/ImageWidgetInUpdateView.dart';
import '../shared/widgets/ProductCateASubCategoryDropdownMenu.dart';
import '../shared/widgets/ShopCategoryDropDownMenu.dart';

class updateProductView extends ConsumerStatefulWidget {
  ProductModel product;
  updateProductView({required this.product});

  @override
  ConsumerState<updateProductView> createState() => _updateProductViewState();
}

class _updateProductViewState extends ConsumerState<updateProductView> {
  final formkey = GlobalKey<FormState>();
  late TextEditingController name = TextEditingController();
  final TextEditingController subtitle = TextEditingController();
  late TextEditingController price = TextEditingController();
  late TextEditingController description = TextEditingController();
  late TextEditingController stock = TextEditingController();

  @override
  void initState() {
    super.initState();

    /// WidgetsBinding.addPostFrameCallback to perform provider modifications after the widget tree is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(updateProductProvider(widget.product.id.toString()).notifier)
          .initValues(widget.product.id.toString())
          .then((_) {
            final product =
                ref
                    .read(updateProductProvider(widget.product.id.toString()))
                    .value;
            print('Loaded product: ${product}');
            if (product != null) {
              name.text = product.name!;
              subtitle.text=product.subtitle!;
              price.text = product.price.toString();
              description.text = product.description!;
              stock.text = product.stock.toString();
            }
          });
      ref
          .read(updateProductProvider(widget.product.id.toString()).notifier)
          .getCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(
      updateProductProvider(widget.product.id.toString()),
    );
    return Scaffold(
      appBar: AppBar(title: Text("Update Product")),
      body: state.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (shop) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Form(
                key: formkey,
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    if (state.value?.images != null &&
                        state.value!.images!.isNotEmpty)
                      Container(
                        height: 120.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.value?.images?.length ?? 0,
                          itemBuilder: (context, index) {
                            final image = state.value!.images?[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(
                                children: [
                                  Container(
                                    width: 100.w,
                                    height: 100.h,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.r),
                                      child: UpdateImage(image),
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
                                        ref
                                            .read(
                                              updateProductProvider(
                                                widget.product.id.toString(),
                                              ).notifier,
                                            )
                                            .removeImage(index);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                    ElevatedButton(
                      onPressed: () {
                        ref
                            .read(
                              updateProductProvider(
                                widget.product.id.toString(),
                              ).notifier,
                            )
                            .pickImages(context);
                      },
                      child: Text("Upload Images"),
                    ),
                    TextFormField(
                      controller: name,
                      decoration: InputDecoration(labelText: "Product Name"),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a Product name";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: price,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: "Price"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter Price";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: subtitle,
                      decoration: InputDecoration(labelText: "Subtitle"),
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter Description";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: stock,
                      decoration: InputDecoration(labelText: "Stock"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter Stock";
                        }
                        return null;
                      },
                    ),
                    updateProductCategoryDropdown(
                      shopid: widget.product.id.toString(),
                    ),
                    updateProductSubcategoryDropdown(
                      shopId: widget.product.id.toString(),
                    ),
                    SizedBox(height: 20.h),
                    ElevatedButton(
                      onPressed:
                          state.isLoading
                              ? null
                              : () async {
                                if (formkey.currentState!.validate()) {
                                  print(
                                    "Name: ${name.text}, Price: ${price.text}, Description: ${description.text}, Stock: ${stock.text}",
                                  ); // Debugging line
                                  await ref
                                      .read(
                                        updateProductProvider(
                                          widget.product.id.toString(),
                                        ).notifier,
                                      )
                                      .updateProduct(
                                        name: name.text,
                                        price: int.parse(price.text),
                                        subtitle: subtitle.text,
                                        description: description.text,
                                        stock: int.parse(stock.text),
                                        shopId: widget.product.shopid.toString(),
                                        user: widget.product.seller.toString(),
                                        context: context,
                                      );
                                }
                              },
                      child:
                          state.isLoading
                              ? Center(
                                child: CircularProgressIndicator(
                                  color: Appcolors.blueColor,
                                ),
                              )
                              : const Text('Update Product'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
