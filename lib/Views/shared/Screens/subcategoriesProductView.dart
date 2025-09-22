import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../View_Model/SharedViewModels/subCategoriesProductViewModel.dart';
import '../../../core/utils/colors.dart';
import '../widgets/loadingState.dart';
import '../widgets/productCard.dart';

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
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final productState = ref.watch(subCategoryProductViewModelProvider(widget.name));

          return productState.when(
            loading: () => const Column(
              children: [
                ShimmerListTile(),
                ShimmerListTile(),
              ],
            ),
            data: (products) {
              if (products.isEmpty) {
                return const Center(child: Text("No Products available."));
              }
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 2.w,
                  mainAxisSpacing: 15.h,
                  childAspectRatio: 0.70,
                ),
                itemCount: products.length,
                physics: const ScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemBuilder: (context, index) {
                  final product = products[index];
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
