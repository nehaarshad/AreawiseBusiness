import 'package:ecommercefrontend/core/utils/routes/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../View_Model/SharedViewModels/productViewModels.dart';

class ProductsView extends ConsumerStatefulWidget {
  int userid;
  ProductsView({required this.userid});

  @override
  ConsumerState<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends ConsumerState<ProductsView> {

  @override
  void initState() {
    super.initState();
    // Fetch all products when the widget is first created
    ref.read(sharedProductViewModelProvider.notifier).getAllProduct();
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(sharedProductViewModelProvider);
    return productState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (products) {
        if (products.isEmpty) {
          return const Center(child: Text("No Products available."));
        }
        return Column(
          children: [
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 0.8,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, routesName.productdetail,
                      arguments: {'id': widget.userid, 'product': product},);
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
                              child:
                                  product?.images != null && product!.images!.isNotEmpty
                                      ? Image.network(
                                        product.images!.first.imageUrl!,
                                        fit: BoxFit.fill,
                                        width: double.infinity,
                                      )
                                      : const Icon(Icons.image_not_supported),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                product?.name ?? "Unknown",
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text("\$${product?.price ?? 0}", style: const TextStyle(color: Colors.green)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
