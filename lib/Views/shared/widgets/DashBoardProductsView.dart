import 'package:ecommercefrontend/core/utils/routes/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../FutureProviders/ProductsViewModel.dart';

class Products extends ConsumerStatefulWidget {
  int userid;
   Products({required this.userid}) ;

  @override
  ConsumerState<Products> createState() => _ProductsViewState();
}

class _ProductsViewState extends ConsumerState<Products> {
  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(getAllProductProvider);
    return productState.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      data: (products) {
        if (products.isEmpty) {
          return const Center(
            child: Text("No Products available."),
          );
        }
        return SizedBox(
          height: 250, // Fixed height to prevent unbounded height
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              itemBuilder: (context, index)
        {
          final product = products[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                  context, routesName.productdetail, arguments: {
                    'id':widget.userid,
                    'product':product});
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
                      child: product?.images != null &&
                          product!.images!.isNotEmpty
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
                        product?.name ?? "Unknown",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "\$${product?.price ?? 0}",
                        style: const TextStyle(color: Colors.green),
                      ),
                    ),
                    SizedBox(height: 20,)
                  ],
                ),
              ),
            ),
          );
        })
        );

      },
      error: (err, stack) => Center(
        child: Text('Error: $err'),
      ),
    );
  }
}
