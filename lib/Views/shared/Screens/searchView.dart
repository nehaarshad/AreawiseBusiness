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
    final productState = ref.watch(sharedProductViewModelProvider);

    return Scaffold(
        backgroundColor: Appcolors.whiteColor,

        body: Column(
            children: [
              SizedBox(height: 60.h,),
              searchBar(id: widget.userid,),
              SizedBox(height: 8.h,),
              productState.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  data: (products) {
                    print(products);
                    if (products.isEmpty) {
                      return const Center(child: Text("No Products found!."));
                    }
                    return Expanded(
                      child: SizedBox(
                       // height: 500.h, // Fixed height to prevent unbounded height
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Number of columns in the grid
                            crossAxisSpacing: 8, // Horizontal spacing between grid items
                            mainAxisSpacing: 20, // Adjust based on the desired item dimensions
                          ),
                          itemCount: products.length,
                          physics: ScrollPhysics(),
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  routesName.productdetail,
                                  arguments: {'id': widget.userid, 'product': product},
                                );
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0.r),
                                ),
                                child: Container(
                                  width: 170.w,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: product?.images != null && product!.images!.isNotEmpty
                                            ? Image.network(
                                          product.images!.first.imageUrl!,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        )
                                            : const Icon(Icons.image_not_supported),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  product?.name ?? "Unknown",
                                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                              WishlistButton( userId: widget.userid.toString(),product:product!),
                                            ],
                                          ),
                                          Padding(
                                            padding:  EdgeInsets.symmetric(horizontal: 8.0.w),
                                            child: Text(
                                              "Rs.${product.price ?? 0}",
                                              style: const TextStyle(color: Colors.green),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                  error: (err, stack) => Center(child: Text('Error: $err')),
                ),

            ],
          ),

      );
  }
}
