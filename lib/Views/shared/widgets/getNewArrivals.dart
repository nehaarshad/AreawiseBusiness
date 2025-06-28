import 'package:ecommercefrontend/Views/shared/widgets/wishListButton.dart';
import 'package:ecommercefrontend/core/utils/routes/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../View_Model/SharedViewModels/NewArrivalsViewModel.dart';
import '../../../core/utils/utils.dart';

class NewArrivals extends ConsumerStatefulWidget {
  int userid;
  NewArrivals({required this.userid});

  @override
  ConsumerState<NewArrivals> createState() => _ProductsViewState();
}

class _ProductsViewState extends ConsumerState<NewArrivals> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (mounted ) {

        ref.read(newArrivalViewModelProvider.notifier).getNewArrivalProduct('All');
      }
    });

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(newArrivalViewModelProvider.notifier).getNewArrivalProduct('All');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(newArrivalViewModelProvider);
    return productState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (products) {
        if (products.isEmpty) {
          return const Center(child: Text("No New Products available."));
        }
        return SizedBox(
          height: 180.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return GestureDetector(
                onTap: () {
                  print(product!);
                  if (product != null) {
                    Navigator.pushNamed(
                      context,
                      routesName.productdetail,
                      arguments: {
                        'id': widget.userid,
                        'product': product
                      },
                    );
                  } else {
                    Utils.toastMessage("Product information is not available");
                  }
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
                            product!.images!.first.imageUrl!,
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
                                "Rs.${product?.price ?? 0}",
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
        );
      },
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
