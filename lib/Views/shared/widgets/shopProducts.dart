import 'package:ecommercefrontend/Views/shared/widgets/productCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../View_Model/SharedViewModels/productViewModels.dart';
import '../../../core/utils/colors.dart';

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
      loading: () =>  Center(
        child: SizedBox(
          height: 100.h,
          child: Center(child: LinearProgressIndicator(color: Appcolors.baseColor,)),
        ),
      ),
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
        return SizedBox(
          height: 220.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Productcard(product: product!,userid: int.tryParse(widget.id) ?? 0,);
            },
          ),
        );

      },
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
