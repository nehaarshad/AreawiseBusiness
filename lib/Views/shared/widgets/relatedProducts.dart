import 'package:ecommercefrontend/Views/shared/widgets/productCard.dart';
import 'package:ecommercefrontend/models/ProductModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../View_Model/SharedViewModels/locationSelectionViewModel.dart';
import '../../../View_Model/SharedViewModels/productViewModels.dart';
import '../../../core/utils/colors.dart';
import 'loadingState.dart';

class RelatedProducts extends ConsumerStatefulWidget {
  final int userid;
  final String? category;

  const RelatedProducts({
    required this.userid,
    required this.category,
    Key? key
  }) : super(key: key);

  @override
  ConsumerState<RelatedProducts> createState() => _RelatedProductsState();
}

class _RelatedProductsState extends ConsumerState<RelatedProducts> {
  @override
  void initState() {
    super.initState();
    // Fetch products by category when widget initializes
    if (widget.category != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(sharedProductViewModelProvider.notifier)
            .getAllProduct(widget.category!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to the product state
    final productState = ref.watch(sharedProductViewModelProvider);
    final location = ref.watch(selectLocationViewModelProvider);

    return productState.when(
      loading: () => const ShimmerListTile(),

      data: (products) {
        // Filter products to show only ones in the same category
        List<ProductModel?> relatedProducts = products.where((product) =>
        product?.category?.name == widget.category ).toList();

        if (relatedProducts.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0.h),
              child: Text(
                "No related products available.",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }
        if (location != null) {
          relatedProducts = relatedProducts.where((areaProducts) {
            final normalizedArea = (areaProducts?.shop?.sector ?? "")
                .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')
                .toLowerCase();

            final normalizedLocation = location
                .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')
                .toLowerCase();

            return normalizedArea.contains(normalizedLocation);
          }).toList();
        }

        return SizedBox(
          height: 220.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: relatedProducts.length,
            itemBuilder: (context, index) {
              final product = relatedProducts[index];
              return Productcard(product: product!,userid: widget.userid);

            },
          ),
        );
      },
      error: (err, stack) => Center(child: Text('Error while loading')),
    );
  }
}