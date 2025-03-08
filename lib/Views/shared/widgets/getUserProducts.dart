import 'package:ecommercefrontend/Views/shared/widgets/SetDateTime.dart';
import 'package:ecommercefrontend/core/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../../View_Model/SellerViewModels/createFeatureProductViewModel.dart';
import '../../../View_Model/SharedViewModels/productViewModels.dart';
import '../../../core/utils/routes/routes_names.dart';
import 'colors.dart';

class getSellerProductView extends ConsumerStatefulWidget {
  final String sellerId;
  getSellerProductView({required this.sellerId});

  @override
  ConsumerState<getSellerProductView> createState() => _getSellerProductView();
}

class _getSellerProductView extends ConsumerState<getSellerProductView> {
  DateTime? selectedDate;
  final key = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(sharedProductViewModelProvider.notifier).getUserProduct(widget.sellerId);
    });
  }

  Future<void> featureProduct(BuildContext context, String sellerId, int productId) async {
    selectedDate = null;
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
            builder: (stateContext, setDialogState) {
              return AlertDialog(
                title: const Text("Feature Product"),
                content: Form(
                  key: key,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Set expiration date and time for featuring this product:"),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () async {
                          final DateTime? dateTime = await setDateTime(stateContext);
                          if (dateTime != null) {
                            setDialogState(() {
                              selectedDate = dateTime; // Update selectedDate in dialog state
                            });
                            await ref.read(createfeatureProductViewModelProvider.notifier)
                                .selectExpirationDateTime(dateTime);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(selectedDate != null
                                  ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year} at ${selectedDate!.hour}:${selectedDate!.minute.toString().padLeft(2, '0')}"
                                  : "Select Date and Time"),
                              Icon(Icons.calendar_today, color: Colors.blue),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(dialogContext, false); // Cancel
                        },
                        child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(dialogContext, true); // Confirm with true result
                        },
                        child: const Text("Request to Feature", style: TextStyle(color: Appcolors.blueColor)),
                      ),
                    ],
                  ),
                ],
              );
            }
        );
      },
    );

    // Process the result outside the dialog context
    if (result == true) {
      try {
        await ref.read(createfeatureProductViewModelProvider.notifier).createFeatureProduct(
          sellerId.toString(),
          productId,
          context, // Using the parent context which is still valid
        );
        Utils.flushBarErrorMessage("Product feature request sent successfully!", context);
      } catch(e) {
        Utils.flushBarErrorMessage("Failed to send feature request. Please try again.", context);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(sharedProductViewModelProvider);
    print("Product State: $productState"); // Debugging

    return Column(
      children: [
        Text("My Products", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        Consumer(
          builder: (context, ref, child) {
            return productState.when(
              loading: () => const Center(child: CircularProgressIndicator(color: Appcolors.blueColor)),
              data: (products) {
                if (products.isEmpty) {
                  return const Center(child: Text("No Products Available"));
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
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            routesName.productdetail,
                            arguments: {'id': int.tryParse(widget.sellerId), 'product': product},
                          );
                        },
                        child: ListTile(
                          leading: (product.images != null &&
                              product.images!.isNotEmpty &&
                              product.images!.first.imageUrl != null)
                              ? Image.network(
                            product.images!.first.imageUrl!,
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error);
                            },
                          )
                              : const Icon(Icons.image_not_supported),
                          title: Text(product.name ?? 'No Name'),
                          subtitle: Text(
                            product.category?.name ?? 'No Category',
                            style: const TextStyle(fontSize: 12),
                          ),
                          trailing: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        .deleteProduct(product.id.toString(), widget.sellerId);
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.star_border),
                                onPressed: () async {
                                    await featureProduct(context, widget.sellerId, product.id!);
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
              error: (error, stackTrace) => Center(child: Text('Error: ${error.toString()}')),
            );
          },
        ),
      ],
    );
  }
}