import 'package:ecommercefrontend/models/ProductModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../View_Model/SharedViewModels/locationSelectionViewModel.dart';
import '../../../View_Model/SharedViewModels/subCategoriesProductViewModel.dart';
import '../../../core/utils/colors.dart';
import '../widgets/loadingState.dart';
import '../widgets/productCard.dart';
import '../widgets/selectAreafloatingButton.dart';

class Subcategoriesproductview extends ConsumerStatefulWidget {
  final int userid;
  final String name;
  const Subcategoriesproductview({super.key,required this.userid,required this.name});

  @override
  ConsumerState<Subcategoriesproductview> createState() => _SubcategoriesproductviewState();
}

class _SubcategoriesproductviewState extends ConsumerState<Subcategoriesproductview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.name}",style: TextStyle(fontSize: 18.sp),),
      ),
      floatingActionButton: selectLocationFloatingButton(),
      body: Consumer(
        builder: (context, ref, child) {
          final productState = ref.watch(subCategoryProductViewModelProvider(widget.name));
          final location = ref.watch(selectLocationViewModelProvider);

          return productState.when(
            loading: () => const Column(
              children: [
                ShimmerListTile(),
                ShimmerListTile(),
              ],
            ),
            data: (products) {

              print(products.map((s)=>s!.shop?.shopname).toList());
              List<ProductModel?> activeProducts = products
                  .where((product) =>
              product != null &&
                  product.shop?.status == "Active")
                  .toList();
              print(activeProducts.map((p)=>p!.shop!.status!));

              if (activeProducts.isEmpty) {
                return const Center(child: Text("Oops! No products available."));
              }
              if (location != null) {
                activeProducts = activeProducts.where((areaProducts) {
                  final normalizedArea = (areaProducts?.shop?.sector ?? "")
                      .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')
                      .toLowerCase();

                  final normalizedLocation = location
                      .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')
                      .toLowerCase();

                  return normalizedArea.contains(normalizedLocation);
                }).toList();
              }


              if (activeProducts.isEmpty) {
                return const Center(child: Text("Oops! No products found in this location."));
              }

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 2.w,
                  mainAxisSpacing: 15.h,
                  childAspectRatio: 0.70,
                ),
                itemCount: activeProducts.length,
                physics: const ScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemBuilder: (context, index) {
                  final product = activeProducts[index];
                  if (product?.name == null)  return const Center(child: Text("No Products available."));

                  return Productcard(product: product!,userid: widget.userid);
                },
              );
            },
            error: (err, stack) => Center(child: Text('Error: ${err.toString()}')),
          );
        },
      ),
    );
  }
}
