import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../View_Model/SharedViewModels/productViewModels.dart';
import '../../../View_Model/SharedViewModels/searchProductViewModel.dart';
import '../../../core/utils/routes/routes_names.dart';
import '../widgets/productCard.dart';
import '../widgets/searchBar.dart';
import '../widgets/wishListButton.dart';

class searchView extends ConsumerStatefulWidget {
  final String search;
  final int userid;
  searchView({super.key,required this.search,required this.userid});

  @override
  ConsumerState<searchView> createState() => _searchViewState();
}

class _searchViewState extends ConsumerState<searchView> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(searchProductViewModelProvider.notifier).searchProduct(widget.search);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.whiteSmoke,
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.only(top: 18.0.h,left: 8.w,right: 8.w,bottom: 5.h),
          child: Consumer(
            builder: (context, ref, child) {
              final productState = ref.watch(searchProductViewModelProvider);

              return productState.when(
                loading: () => const Center(child: LinearProgressIndicator(color: Appcolors.baseColor,)),
                data: (products) {
                  if (products.isEmpty) {
                    return const Center(child: Text("No Products available."));
                  }
                  return SizedBox(
                    height: 700.h,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 2.w,
                        mainAxisSpacing: 18.h,
                        childAspectRatio: 0.65,
                      ),
                      itemCount: products.length,
                      physics: const ScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        if (product == null) return const SizedBox.shrink();

                        return Productcard(product: product!,userid: widget.userid);
                      },
                    ),
                  );
                },
                error: (err, stack) => Center(child: Text('Error: ${err.toString()}')),
              );
            },
          ),
        ),
      ),
    );
  }
}