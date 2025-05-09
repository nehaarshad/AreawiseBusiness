import 'package:ecommercefrontend/Views/shared/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../View_Model/SellerViewModels/createFeatureProductViewModel.dart';
import '../../View_Model/SharedViewModels/featuredProductViewModel.dart';
import '../../core/utils/routes/routes_names.dart';
import '../../core/utils/utils.dart';
import '../shared/widgets/SetDateTime.dart';


class Featuredproductrequestview extends ConsumerStatefulWidget {
  String id;
  Featuredproductrequestview({super.key, required this.id});

  @override
  ConsumerState<Featuredproductrequestview> createState() => _FeaturedproductrequestviewState();
}

class _FeaturedproductrequestviewState extends ConsumerState<Featuredproductrequestview>{
  bool _isLoading = false;
  final key = GlobalKey<FormState>();
  DateTime? selectedDate;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
    await  ref.read(featureProductViewModelProvider(widget.id).notifier)
        .getAllRequestedFeatured();
    });
  }


  Future<void> updateFeatureStatus(String featureId, String userId, String status, DateTime expireAt) async {
    // Convert DateTime to ISO string format for proper serialization
    final data = {
      "status": status,
      "expire_at": expireAt.toIso8601String() // Convert DateTime to ISO string
    };

    await ref.read(createfeatureProductViewModelProvider.notifier)
        .updateFeatureProduct(featureId, userId, data, context);
  }

  Future<void> featureProduct(BuildContext context, String featureId, String userId) async {
    selectedDate = null;
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
            builder: (stateContext, setDialogState) {
              return AlertDialog(
                title: const Text("Update Expiration Time"),
                content: Form(
                  key: key,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                          Navigator.pop(dialogContext, false);
                        },
                        child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
                      ),
                      TextButton(
                        onPressed: () async {
                          if (selectedDate != null) {
                            await updateFeatureStatus(featureId, userId, 'Featured', selectedDate!);
                            Navigator.pop(dialogContext, true);
                          } else {
                            // Show error that date is required
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Please select an expiration date'))
                            );
                          }
                        },
                        child: const Text("Feature", style: TextStyle(color: Appcolors.blueColor)),
                      ),
                    ],
                  ),
                ],
              );
            }
        );
      },
    );

    // If result is true, refresh the REQUESTED products list
    if (result == true) {
    await  ref.read(featureProductViewModelProvider(widget.id).notifier)
        .getAllRequestedFeatured();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Required for AutomaticKeepAliveClientMixin
    final featureState = ref.watch(featureProductViewModelProvider(widget.id));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Requests to Feature Products", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed:  () {
              ref.read(featureProductViewModelProvider(widget.id).notifier)
                  .getAllRequestedFeatured();
            },
          ),
        ],
      ),
      backgroundColor: Appcolors.whiteColor,
      body: Column(
        children: [
          Expanded(
            child: featureState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              data: (featuredProducts) {
                if (featuredProducts.isEmpty) {
                  return Center(
                    child: Text(
                      "No featured product requests available",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                // Filter to show only products with 'Requested' status
                final requestedProducts = featuredProducts
                    .where((product) => product?.status == 'Requested')
                    .toList();

                if (requestedProducts.isEmpty) {
                  return Center(
                    child: Text(
                      "No pending requests available",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: requestedProducts.length,
                  itemBuilder: (context, index) {
                    final featuredProduct = requestedProducts[index];
                    if (featuredProduct == null) return SizedBox.shrink();

                    return Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      child: ListTile(
                          leading: (featuredProduct.product?.images != null &&
                              featuredProduct.product!.images!.isNotEmpty &&
                              featuredProduct.product?.images!.first.imageUrl != null)
                              ? Image.network(
                            featuredProduct.product!.images!.first.imageUrl!,
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error);
                            },
                          )
                              : const Icon(Icons.image_not_supported),
                          title: Text(
                            "${featuredProduct.product?.name ?? 'Unknown Product'}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "${featuredProduct.status ?? 'Unknown'}",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.check, color: Colors.green),
                                onPressed:() async {
                                  if (featuredProduct.id != null && featuredProduct.userID != null) {
                                    await featureProduct(context, featuredProduct.id.toString() , featuredProduct.userID.toString());
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.red),
                                onPressed: () async {
                                  if (featuredProduct.id != null && featuredProduct.userID != null) {
                                    await ref.read(featureProductViewModelProvider(widget.id).notifier)
                                        .deleteFeatureProduct(featuredProduct.id.toString(), featuredProduct.userID.toString(), context);
                                  }
                                },
                              ),
                            ],
                          )
                      ),
                    );
                  },
                );
              },
              error: (err, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 48),
                      SizedBox(height: 16),
                      Text(
                        "Error loading featured product requests: $err",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(featureProductViewModelProvider(widget.id).notifier)
                              .getAllRequestedFeatured();
                        },
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              routesName.activefeature,
              arguments: widget.id,//send userId
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Appcolors.blueColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.0),
            ),
            padding: EdgeInsets.symmetric(vertical: 12),
          ),
          child: const Text(
            "Featured Products",
            style: TextStyle(
              color: Appcolors.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}