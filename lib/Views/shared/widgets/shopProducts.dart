import 'package:ecommercefrontend/Views/shared/widgets/productCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../View_Model/SharedViewModels/productViewModels.dart';
import '../../../core/utils/colors.dart';
import 'loadingState.dart';

class shopProducts extends ConsumerStatefulWidget {
  String shopId;
  String id;//userId
  shopProducts({required this.shopId,required this.id});

  @override
  ConsumerState<shopProducts> createState() => _ProductsViewState();
}

class _ProductsViewState extends ConsumerState<shopProducts> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_)  {
      if (mounted) {
        ref.invalidate(sharedProductViewModelProvider);
         ref.read(sharedProductViewModelProvider.notifier).getShopProduct(
            widget.shopId);
      }  });
  }

  @override
  Widget build(BuildContext context) {
    final productState =ref.watch(sharedProductViewModelProvider);
    return productState.when(
      loading: () => const  ShimmerListTile(),

      data: (products) {
        if (products.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0.h),
              child: Text(
                "No products available.",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }
        return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 2.w,
              mainAxisSpacing: 18.h,
              childAspectRatio: 0.75,
          ),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Productcard(product: product!,userid: int.tryParse(widget.id) ?? 0,);
              },
            );

      },
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
