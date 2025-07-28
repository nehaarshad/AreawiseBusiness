import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../View_Model/SharedViewModels/productViewModels.dart';
import '../../../core/utils/routes/routes_names.dart';
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
      await ref.read(sharedProductViewModelProvider.notifier).searchProduct(widget.search);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.whiteColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  IconButton(
                      onPressed: () async {
                        await ref.read(sharedProductViewModelProvider.notifier).getAllProduct("All");
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back)
                  ),
        
                  SizedBox(height: 10.h),
                ],
              ),
            ),
        
            Consumer(builder: (context, ref, child) {
              final productState = ref.watch(sharedProductViewModelProvider);
              return productState.when(
                loading: () => SliverToBoxAdapter(
                  child: SizedBox(
                    height:60.h,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ),
                data: (products) {
                  print(products);
                  if (products.isEmpty) {
                    return SliverToBoxAdapter(
                      child: SizedBox(
                        height: 60.h,
                        child: const Center(child: Text("No Products found!.")),
                      ),
                    );
                  }
                  return SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 20,
                    ),
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        print(products[index]);
                        final product = products[index];
                        if (product == null) {
                          return SizedBox.shrink();
                        }
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              routesName.productdetail,
                              arguments: {'id': widget.userid, 'product': product},
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 5.h),
                            width: 170.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child:Stack(
                                      children: [
                                        product?.images != null && product!.images!.isNotEmpty
                                            ? Image.network(
                                          product!.images!.first.imageUrl!,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        )
                                            : const Icon(Icons.image_not_supported),
                                        Positioned(
                                            child: Align(
                                              alignment: Alignment.topRight,
                                              child: Container(
                                                height: 35,
                                                width: 35,
                                                decoration: BoxDecoration(
                                                    color: Appcolors.blueColor,
                                                    borderRadius: BorderRadius.only(
                                                        topRight: Radius.circular(0),
                                                        bottomLeft: Radius.circular(20)
                                                    )
                                                ),
                                                child:  WishlistButton(color: Appcolors.whiteColor, userId: widget.userid.toString(),product:product!),

                                              ),
                                            )
                                        ),
                                      ],
                                    )
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Padding(
                                      padding:  EdgeInsets.only(top: 0.0.h,left: 6.h),
                                      child: Text(
                                        product.name ?? "Unknown",
                                        style: const TextStyle(fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    // WishlistButton( userId: widget.userid.toString(),product:product!),

                                    Padding(
                                      padding:  EdgeInsets.symmetric(horizontal: 8.0.w),
                                      child: Text(
                                        "Rs.${product.price ?? 0}",
                                        style:  TextStyle(color: Colors.green,fontSize: 13.h),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: products.length,
                    ),
                  );
                },
                error: (err, stack) => SliverToBoxAdapter(
                  child: SizedBox(
                    height: 60.h,
                    child: Center(child: Text('Error: $err')),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}