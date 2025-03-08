import 'package:ecommercefrontend/core/utils/routes/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../View_Model/SharedViewModels/featuredProductViewModel.dart';

class allFeaturedProducts extends ConsumerStatefulWidget {
  int userid;
  allFeaturedProducts({required this.userid});

  @override
  ConsumerState<allFeaturedProducts> createState() => _allFeaturedProductsState();
}

class _allFeaturedProductsState extends ConsumerState<allFeaturedProducts> {

  @override
  void initState() {
    super.initState();
    ref.read(featureProductViewModelProvider.notifier).getAllFeaturedProducts();
  }

  @override
  Widget build(BuildContext context) {
    final featuredProducts = ref.watch(featureProductViewModelProvider);
    return featuredProducts.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (products) {
        if (products.isEmpty) {
          return const Center(child: Text("No Featured Products available."));
        }
        return SizedBox(
          height: 200, //
          child: ListView.builder(
            //physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    routesName.productdetail,
                    arguments: {'id': widget.userid, 'product': product!.product},
                  );
                },
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                    width: 130,
                    margin: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: product?.product?.images != null && product!.product!.images!.isNotEmpty
                              ? Image.network(product.product!.images!.first.imageUrl!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          )
                              : const Icon(Icons.image_not_supported),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            product?.product?.name ?? "Unknown",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
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
