import 'package:ecommercefrontend/View_Model/SellerViewModels/updateProductViewModel.dart';
import 'package:ecommercefrontend/Views/sellerscrens/widgets/productCondition.dart';
import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../models/ProductModel.dart';
import '../shared/widgets/ImageWidgetInUpdateView.dart';
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
              condition=ProductCondition.fromString(product.condition.toString());
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
                    SizedBox(height: 20.h),
                    InkWell(
                      onTap:  state.isLoading
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
                            condition:condition.value,
                            shopId: widget.product.shopid.toString(),
                            user: widget.product.seller.toString(),
                            context: context,
                          );
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
