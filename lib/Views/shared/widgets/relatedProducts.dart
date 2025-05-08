import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../View_Model/SharedViewModels/productViewModels.dart';
import '../../../core/utils/routes/routes_names.dart';

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

    return productState.when(
      loading: () => const Center(
        child: SizedBox(
          height: 100,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      data: (products) {
        // Filter products to show only ones in the same category
        final relatedProducts = products.where((product) =>
        product?.category?.name == widget.category).toList();

        if (relatedProducts.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                "No related products available.",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        return SizedBox(
          height: 250, // Fixed height to prevent unbounded height
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: relatedProducts.length,
            itemBuilder: (context, index) {
              final product = relatedProducts[index];
              if (product == null) return const SizedBox.shrink();

              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    routesName.productdetail,
                    arguments: {'id': widget.userid, 'product': product},
                  );
                },
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                    width: 150,
                    margin: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: product.images != null && product.images!.isNotEmpty
                              ? Image.network(
                            product.images!.first.imageUrl!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          )
                              : const Icon(Icons.image_not_supported),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            product.name ?? "Unknown",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "\$${product.price ?? 0}",
                            style: const TextStyle(color: Colors.green),
                          ),
                        ),
                        const SizedBox(height: 8),
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