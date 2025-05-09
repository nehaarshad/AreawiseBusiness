import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../View_Model/SellerViewModels/createFeatureProductViewModel.dart';
import '../../View_Model/SharedViewModels/productViewModels.dart';
import '../../core/utils/routes/routes_names.dart';
import '../shared/widgets/colors.dart';

class AllProductsview extends ConsumerStatefulWidget {
  final int id;
  const AllProductsview({required this.id});

  @override
  ConsumerState<AllProductsview> createState() => _AllProductsviewState();
}

class _AllProductsviewState extends ConsumerState<AllProductsview> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(sharedProductViewModelProvider.notifier).getAllProduct('All');
    });
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(sharedProductViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("All Products"),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer(
                  builder: (context, ref, child) {
                    return productState.when(
                      loading: () => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(color: Appcolors.blueColor),
                        ),
                      ),
                      data: (products) {
                        if (products.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text("No Products Available"),
                            ),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            if (product == null) {
                              return const SizedBox.shrink();
                            }
                            return Card(
                              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    routesName.productdetail,
                                    arguments: {'id': widget.id, 'product': product},
                                  );
                                },
                                child: Column(
                                  children: [
                                    ListTile(
                                      contentPadding: EdgeInsets.all(10),
                                      leading: Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        clipBehavior: Clip.antiAlias,
                                        child: (product.images != null &&
                                            product.images!.isNotEmpty &&
                                            product.images!.first.imageUrl != null)
                                            ? Image.network(
                                          product.images!.first.imageUrl!,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return const Icon(Icons.error);
                                          },
                                        )
                                            : const Icon(Icons.image_not_supported, size: 40),
                                      ),
                                      title: Text(
                                        product.name ?? 'No Name',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        product.category?.name ?? 'No Category',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  Navigator.pushNamed(
                                                    context,
                                                    routesName.sEditProduct,
                                                    arguments: product,
                                                  );
                                                },
                                                icon: Icon(Icons.edit, color: Appcolors.blueColor),
                                                tooltip: "Edit Product",
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.delete, color: Colors.red),
                                                onPressed: () async {
                                                  if (product.id != null) {
                                                    await ref.read(sharedProductViewModelProvider.notifier)
                                                        .deleteProduct(product.id.toString(), widget.id.toString());
                                                    await ref.read(sharedProductViewModelProvider.notifier).getAllProduct('All');
                                                  }
                                                },
                                                tooltip: "Delete Product",
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
            
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      error: (error, stackTrace) => Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Icon(Icons.error_outline, color: Colors.red, size: 48),
                              SizedBox(height: 16),
                              Text('Error loading products: ${error.toString()}'),
                              SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  ref.read(sharedProductViewModelProvider.notifier).getUserProduct(widget.id.toString());
                                },
                                child: Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          )
      ),
    );
  }
}