import 'package:ecommercefrontend/Views/shared/widgets/productCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../View_Model/SharedViewModels/productViewModels.dart';
import '../../../core/utils/colors.dart';
import 'loadingState.dart';


class AllProducts extends ConsumerStatefulWidget {
  int userid;
  AllProducts({required this.userid});

  @override
  ConsumerState<AllProducts> createState() => _ProductsViewState();
}

class _ProductsViewState extends ConsumerState<AllProducts> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(sharedProductViewModelProvider.notifier).getAllProduct('All');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final productState = ref.watch(sharedProductViewModelProvider);

        return productState.when(
          loading: () => const  ShimmerListTile(),

          data: (products) {
            if (products.isEmpty) {
              return const Center(child: Text("No Products available."));
            }
            return SizedBox(
              height: 480.h,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 2.w,
                  mainAxisSpacing: 18.h,
                  childAspectRatio: 0.70,
                ),
                itemCount: products.length,
                physics: const ScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemBuilder: (context, index) {
                  final product = products[index];
                  if (product == null) return const SizedBox.shrink();

                  return Productcard(product: product,userid: widget.userid,);
                },
              ),
            );
          },
          error: (err, stack) => Center(child: Text('Error: ${err.toString()}')),
        );
      },
    );
  }


}