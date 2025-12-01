import 'package:ecommercefrontend/View_Model/SellerViewModels/updateProductViewModel.dart';
import 'package:ecommercefrontend/Views/sellerscrens/widgets/productCondition.dart';
import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../View_Model/SellerViewModels/createFeatureProductViewModel.dart';
import '../../core/utils/notifyUtils.dart';
import '../../models/ProductModel.dart';
import '../shared/widgets/ImageWidgetInUpdateView.dart';
import '../shared/widgets/SetDateTime.dart';
import '../shared/widgets/loadingState.dart';
import 'widgets/ProductCateASubCategoryDropdownMenu.dart';

class updateProductView extends ConsumerStatefulWidget {
  ProductModel product;
  updateProductView({required this.product});

  @override
  ConsumerState<updateProductView> createState() => _updateProductViewState();
}

class _updateProductViewState extends ConsumerState<updateProductView> {

  ProductCondition condition = ProductCondition.New;

  final formkey = GlobalKey<FormState>();
  late TextEditingController name = TextEditingController();
  final TextEditingController subtitle = TextEditingController();
  late TextEditingController price = TextEditingController();
  late TextEditingController description = TextEditingController();
  late TextEditingController stock = TextEditingController();
  final TextEditingController discount = TextEditingController();


  @override
  void initState() {
    super.initState();
 WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(updateProductProvider(widget.product.id.toString()).notifier)
          .initValues(widget.product.id.toString(),widget.product.seller.toString())
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
              condition=ProductCondition.fromString(product.condition.toString());
              ref.read(createfeatureProductViewModelProvider(widget.product.seller.toString()).notifier).setProduct(widget.product);

            }
          });
      ref
          .read(updateProductProvider(widget.product.id.toString()).notifier)
          .getCategories();
    });
  }

  Future<void> addToSale(BuildContext context) async {
    final DateTime? selectedDateTime = await setDateTime(context);
    print(" ${selectedDateTime}");
    if (selectedDateTime != null) {
      ref.read(createfeatureProductViewModelProvider(widget.product.seller.toString()).notifier)
          .selectExpirationDateTime(selectedDateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(
      updateProductProvider(widget.product.id.toString()),
    );
    return Scaffold(
      appBar: AppBar(title: Text("Update Product")),
      body: state.when(
        loading: () => const Column(
          children: [
            ShimmerListTile(),
            ShimmerListTile(),
          ],
        ),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (shop) {
          return SingleChildScrollView(
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: 18.0),
              child: Form(
                key: formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10.h,
                  children: [
                    SizedBox(height: 20.h),
                    if (state.value?.images != null &&
                        state.value!.images!.isNotEmpty)
                      Container(
                        height: 220.h,
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
                                    width: 150.w,
                                    height: 280.h,
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
                    InkWell(
                      onTap: () {
                        ref
                            .read(
                          updateProductProvider(
                            widget.product.id.toString(),
                          ).notifier,
                        )
                            .pickImages(context);    },
                      child: Container(
                        height: 30.h,
                        margin: EdgeInsets.symmetric(horizontal: 25.w),
                        width: 130.w,
                        decoration: BoxDecoration(
                          color: Appcolors.whiteSmoke,
                          borderRadius: BorderRadius.circular(25.r),
                          border: Border.all(  // Use Border.all instead of boxShadow for borders
                            color: Appcolors.baseColor,
                            width: 1.0,  // Don't forget to specify border width
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Upload images",
                            style: TextStyle(
                              color: Appcolors.baseColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h,),
                    TextFormField(
                      controller: name,
                      decoration: InputDecoration(labelText: "Product Name",  border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0.r),
                      ),),

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
                      decoration: InputDecoration(labelText: "Price", border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0.r),
                      ),),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter Price";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: subtitle,
                      decoration: InputDecoration(labelText: "Subtitle", border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0.r),
                      ),),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Provide subtitle of a product";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: description,
                      decoration: InputDecoration(labelText: "Description", border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0.r),
                      ),),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter Description";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: stock,
                      decoration: InputDecoration(labelText: "Stock", border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0.r),
                      ),),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter Stock";
                        }
                        return null;
                      },
                    ),
                    Row(
                      children: [
                        Text('Product Condition', style: TextStyle(fontWeight: FontWeight.w400)),
                        SizedBox(width: 30.w,),
                        Radio(
                          value: ProductCondition.New,
                          groupValue: condition,
                          onChanged: ( value) {
                            setState(() {
                              condition = value!;
                            });
                          },
                        ),
                        Text('New'),
                        SizedBox(width: 15),
                        Radio(
                          value: ProductCondition.Used,
                          groupValue: condition,
                          onChanged: ( value) {
                            setState(() {
                              condition = value!;
                            });
                          },
                        ),
                        Text('Used'),
                      ],
                    ),
                    updateProductCategoryDropdown(
                      shopid: widget.product.id.toString(),
                    ),
                    updateProductSubcategoryDropdown(
                      shopId: widget.product.id.toString(),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Mark as on sale",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18.sp)),
                        Text("  (Optional)",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 15.sp)),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextFormField(
                          controller: discount,
                          decoration: InputDecoration(
                            labelText: "Discount Offer (%)",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0.r),
                            ),
                          ),
                          keyboardType: TextInputType.number,

                        ),
                        Text("Between 1-100",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 12.sp)),

                      ],
                    ),
                    Text(
                      "Select Expiration Date & Time",
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        final addToSaleState = ref.watch(createfeatureProductViewModelProvider(widget.product.seller.toString()));

                        return GestureDetector(
                          onTap: () => addToSale(context),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.0.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    addToSaleState.expirationDateTime != null
                                        ? "${addToSaleState.expirationDateTime!.day}/${addToSaleState.expirationDateTime!.month}/${addToSaleState.expirationDateTime!.year} at ${addToSaleState.expirationDateTime!.hour}:${addToSaleState.expirationDateTime!.minute.toString().padLeft(2, '0')}"
                                        : "Select Date and Time",
                                    style: TextStyle(
                                      color: addToSaleState.expirationDateTime != null
                                          ? Colors.black
                                          : Colors.grey[600],
                                    ),
                                  ),
                                ),
                                Icon(Icons.calendar_today, color: Appcolors.baseColor),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20.h),
                    InkWell(
                      onTap:  state.isLoading
                          ? null
                          : () async {
                        if (formkey.currentState!.validate()) {
                          if (discount.text.trim().isNotEmpty) {
                            final saleState = ref.read(createfeatureProductViewModelProvider(widget.product.seller.toString()));

                            if (saleState.expirationDateTime == null) {
                              Utils.flushBarErrorMessage("Please select expiration date and time for sale", context);
                              return;
                            }
                            final currentProduct = ref.read(updateProductProvider(widget.product.id.toString())).value;
                            if (currentProduct != null) {
                              ref.read(createfeatureProductViewModelProvider(widget.product.seller.toString()).notifier)
                                  .setProduct(currentProduct);
                            }
                          }
                          await ref
                              .read(updateProductProvider(widget.product.id.toString()).notifier).updateProduct(
                                    name: name.text,
                                    price: int.parse(price.text),
                                    subtitle: subtitle.text.trim(),
                                    description: description.text.trim(),
                                    stock: int.parse(stock.text),
                                    condition:condition.value,
                                    discount: discount.text.trim(),
                                    shopId: widget.product.shopid.toString(),
                                    user: widget.product.seller.toString(),
                                    context: context,
                                    );
                          if (discount.text.trim().isNotEmpty) {
                            await ref
                                .read(createfeatureProductViewModelProvider(widget.product.seller.toString()).notifier)
                                .addOnSale(
                              widget.product.seller.toString(),
                              discount.text.trim(),
                              context,
                              widget.product.id,
                            );
                          }
                        }
                      },
                      child: Container(
                        height: 40.h,
                        margin: EdgeInsets.symmetric(horizontal: 25.w),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Appcolors.baseColor,
                          borderRadius: BorderRadius.circular(15.r),

                        ),
                        child: Center(
                          child:state.isLoading
                              ? CircularProgressIndicator(color: Appcolors.whiteSmoke,)
                              : Text(
                            "Save changes",
                            style: TextStyle(
                              color: Appcolors.whiteSmoke,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
                            ),
                          ),
                        ),
                      ),
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
