import 'package:ecommercefrontend/View_Model/adminViewModels/categoriesViewModel.dart';
import 'package:ecommercefrontend/models/categoryModel.dart';
import 'package:ecommercefrontend/models/featureModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../View_Model/SellerViewModels/featuredProductViewModel.dart';
import '../../../View_Model/SharedViewModels/categoryProductsViewModel.dart';
import '../../../View_Model/SharedViewModels/locationSelectionViewModel.dart';
import '../../../core/utils/colors.dart';
import '../../../models/ProductModel.dart';
import '../widgets/loadingState.dart';
import '../widgets/productCard.dart';

class allFeaturedProductsView extends ConsumerStatefulWidget {
  final int userId;
  final String category;
  final String? condition;
  const allFeaturedProductsView({super.key, required this.userId, required this.category,required this.condition});

  @override
  ConsumerState<allFeaturedProductsView> createState() => _ExploreproductsviewState();
}

class _ExploreproductsviewState extends ConsumerState<allFeaturedProductsView> {
  bool _showFilterDropdown = false;
  String? _selectedCondition;
  List<String> conditions = ["New", "Used"];

  @override
  void initState() {
    super.initState();
    _selectedCondition = widget.condition;
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            SizedBox(width: 8.w,height: 8.h,),
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCondition = null;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: _selectedCondition == null
                      ? Appcolors.baseColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: Appcolors.baseColor,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  "All",
                  style: TextStyle(
                    color: _selectedCondition == null
                        ? Colors.white
                        : Appcolors.baseColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            // Condition buttons
            ...conditions.map((condition) => Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCondition = condition;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: _selectedCondition == condition
                        ? Appcolors.baseColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: Appcolors.baseColor,
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    condition,
                    style: TextStyle(
                      color: _selectedCondition == condition
                          ? Colors.white
                          : Appcolors.baseColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            )).toList(),
          ],
        ),

      ),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 10.h,),
              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {

                    final productState = ref.watch(featureProductViewModelProvider(widget.userId.toString()));
                    final location = ref.watch(selectLocationViewModelProvider);

                    return productState.when(
                      loading: () => const Column(
                        children: [
                          ShimmerListTile(),
                          ShimmerListTile(),
                          ShimmerListTile(),
                        ],
                      ),
                      data: (products) {
                        if (products.isEmpty) {
                          return const Center(child: Text("No Products Available."));
                        }
                        List<featureModel?> filteredProducts = [];

                        if (location != null) {
                          filteredProducts = filteredProducts.where((areaProducts) {
                            final normalizedArea = (areaProducts?.product?.shop?.sector ?? "")
                                .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')
                                .toLowerCase();

                            final normalizedLocation = location
                                .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')
                                .toLowerCase();

                            return normalizedArea.contains(normalizedLocation);
                          }).toList();
                        }

                        filteredProducts = _selectedCondition != null
                            ? products.where((product) => product!.product!.condition == _selectedCondition).toList()
                            : products;


                        if (filteredProducts.isEmpty) {
                          return const Center(child: Text("No Products Available!"));
                        }

                        return GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 2.w,
                            mainAxisSpacing: 15.h,
                            childAspectRatio: 0.70,
                          ),
                          itemCount: filteredProducts.length,
                          physics: const ScrollPhysics(),
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];
                            if (product == null) return const SizedBox.shrink();
                            return Productcard(product: product.product!,userid: widget.userId);
                          },
                        );
                      },
                      error: (err, stack) => Center(child: Text('Error: ${err.toString()}')),
                    );
                  },
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}