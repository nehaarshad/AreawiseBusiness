import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../View_Model/SharedViewModels/productViewModels.dart';
import '../../core/utils/routes/routes_names.dart';
import '../shared/widgets/colors.dart';

class Sellerproductsview extends ConsumerStatefulWidget {
  final int id;
  const Sellerproductsview({Key? key, required this.id}) : super(key: key);

  @override
  ConsumerState<Sellerproductsview> createState() => _SellerproductsviewState();
}

class _SellerproductsviewState extends ConsumerState<Sellerproductsview> {
  @override
  void initState() {
    super.initState();
    // Fetch all products when the widget is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(sharedProductViewModelProvider.notifier).getUserProduct(widget.id.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(sharedProductViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(child: Text("My Products")),
      ),
      body: productState.when(
        loading: () => const Center(
            child: CircularProgressIndicator(color: Appcolors.blueColor)
        ),
        data: (products) {
          if (products.isEmpty) {
            return const Center(child: Text("No Products Available"));
          }
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              // Check if product is null before accessing it
              final product = products[index];
              if (product == null) {
                return const SizedBox.shrink(); // Skip null products
              }

              return Card(
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      routesName.productdetail,
                      arguments: {'id': widget.id, 'product': product},
                    );
                  },
                  child: ListTile(
                    // Safely access images
                    leading: (product.images != null &&
                        product.images!.isNotEmpty &&
                        product.images!.first.imageUrl != null)
                        ? Image.network(
                      product.images!.first.imageUrl!,
                      fit: BoxFit.cover,
                      width: 50, // Set a specific width instead of double.infinity
                      height: 50,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error);
                      },
                    )
                        : const Icon(Icons.image_not_supported),

                    // Safely display name
                    title: Text(product.name ?? 'No Name'),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Safely display category - note that this might be null if
                        // you're using the category object instead of a direct category name
                        Text(
                          product.category?.name ?? 'No Category',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
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
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            if (product.id != null) {
                              await ref.read(sharedProductViewModelProvider.notifier)
                                  .deleteProduct(product.id.toString(), widget.id.toString());
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        error: (error, stackTrace) => Center(
            child: Text('Error: ${error.toString()}')
        ),
      ),
    );
  }
}