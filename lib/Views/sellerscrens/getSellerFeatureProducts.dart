import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../View_Model/SellerViewModels/createFeatureProductViewModel.dart';
import '../../View_Model/SharedViewModels/featuredProductViewModel.dart';
import '../shared/widgets/colors.dart';

class UserFeaturedProducts extends ConsumerStatefulWidget {
  final String sellerId;

  const UserFeaturedProducts({
    Key? key,
    required this.sellerId,
  }) : super(key: key);

  @override
  ConsumerState<UserFeaturedProducts> createState() => _UserFeaturedProductsState();
}

class _UserFeaturedProductsState extends ConsumerState<UserFeaturedProducts> {
  @override
  void initState() {
    super.initState();
    // Use Future.microtask to avoid calling setState during build
    Future.microtask(() {
      if (mounted) {
        ref.read(featureProductViewModelProvider(widget.sellerId).notifier)
            .getUserFeaturedProducts(widget.sellerId); // Changed from loadUserFeaturedProducts to getUserFeaturedProducts
      }
    });
  }

  Future<void> deleteFeatured(String featureId) async {
    // Check if the widget is still mounted before showing dialog
    if (!mounted) return;

    return showDialog(
      context: context,
      builder: (BuildContext dialogContext) { // Use dialogContext instead of context
        return AlertDialog(
          title: Text("Are you sure you want to remove this featured product?", style: TextStyle(fontSize: 20)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Use dialogContext
              },
              child: Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                // Pop the dialog first
                Navigator.of(dialogContext).pop();

                // Check if still mounted before proceeding
                if (!mounted) return;

                try {
                  // Show loading indicator
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          CircularProgressIndicator(color: Colors.white),
                          SizedBox(width: 16),
                          Text("Removing featured product...")
                        ],
                      ),
                      duration: Duration(seconds: 2),
                    ),
                  );

                  // Delete the product
                  await ref.read(featureProductViewModelProvider(widget.sellerId).notifier)
                      .deleteFeatureProduct(featureId, widget.sellerId.toString(), context);

                  // Check if still mounted before showing success message
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Product removed successfully"),
                        backgroundColor: Colors.green,
                      ),
                    );

                    // Refresh the list
                    ref.refresh(featureProductViewModelProvider(widget.sellerId));
                  }
                } catch (e) {
                  // Check if still mounted before showing error
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Failed to remove product: ${e.toString()}"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text("Remove", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final featuredProductsState = ref.watch(featureProductViewModelProvider(widget.sellerId));

    return Scaffold(
      backgroundColor: Appcolors.whiteColor,
      appBar: AppBar(
        title: Text(
            "My Featured Products",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            featuredProductsState.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(color: Appcolors.blueColor),
                ),
              ),
              data: (featuredProducts) {
                if (featuredProducts.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Icon(Icons.star_border, size: 48, color: Colors.grey),
                          SizedBox(height: 16),
                          Text("No featured products yet"),
                          SizedBox(height: 8),
                          Text(
                            "Request to feature your products for better visibility",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: featuredProducts.length,
                  itemBuilder: (context, index) {
                    final featuredProduct = featuredProducts[index];
                    final product = featuredProduct!.product;
                    final status = featuredProduct.status;

                    // Get status color
                    Color statusColor;
                    switch (status) {
                      case 'Featured':
                        statusColor = Colors.orange;
                        break;
                      case 'Requested':
                        statusColor = Colors.red;
                        break;
                      default:
                        statusColor = Colors.grey;
                    }

                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.all(12),
                            leading: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: (product?.images != null &&
                                  product!.images!.isNotEmpty &&
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
                              product?.name ?? 'No Name',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: statusColor, width: 0.5),
                                  ),
                                  child: Text(
                                    status ?? 'Unknown',
                                    style: TextStyle(
                                      color: statusColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                if (featuredProduct.expireAt != null) ...[
                                  SizedBox(width: 8),
                                  Icon(Icons.timer_outlined, size: 12, color: Colors.grey),
                                  SizedBox(width: 4),
                                  Text(
                                    "Expires: ${_formatDate(DateTime.parse(featuredProduct.expireAt!))}",
                                    style: TextStyle(fontSize: 10, color: Colors.grey),
                                  ),
                                ],
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                if (featuredProduct.id != null) {
                                  deleteFeatured(featuredProduct.id.toString());
                                }
                              },
                            ),
                          ),
                        ],
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
                      Text('Error loading featured products: ${error.toString()}'),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (mounted) {
                            ref.refresh(featureProductViewModelProvider(widget.sellerId));
                            ref.read(featureProductViewModelProvider(widget.sellerId).notifier)
                                .getUserFeaturedProducts(widget.sellerId); // Changed this line as well
                          }
                        },
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}