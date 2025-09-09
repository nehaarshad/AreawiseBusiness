import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../View_Model/SellerViewModels/createFeatureProductViewModel.dart';
import '../../View_Model/SharedViewModels/featuredProductViewModel.dart';
import '../../core/utils/routes/routes_names.dart';
import '../../core/utils/notifyUtils.dart';
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

    await ref.read(createfeatureProductViewModelProvider(widget.id).notifier)
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
                title: const Text("Expiration DateTime"),
                content: Form(
                  key: key,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                       SizedBox(height: 16.h),
                      GestureDetector(
                        onTap: () async {
                          final DateTime? dateTime = await setDateTime(stateContext);
                          if (dateTime != null) {
                            setDialogState(() {
                              selectedDate = dateTime; // Update selectedDate in dialog state
                            });
                            await ref.read(createfeatureProductViewModelProvider(widget.id).notifier)
                                .selectExpirationDateTime(dateTime);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(selectedDate != null
                                  ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year} at ${selectedDate!.hour}:${selectedDate!.minute.toString().padLeft(2, '0')}"
                                  : "Select Date and Time"),
                              Icon(Icons.calendar_today, color: Appcolors.baseColor),
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
                        child: const Text("Feature", style: TextStyle(color: Appcolors.baseColor)),
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
        automaticallyImplyLeading: false,
        title:  Text("Requests to Feature Products", style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500)),
        actions: [
          IconButton(
            icon:  Icon(Icons.refresh,size: 20.h,),
            onPressed:  () {
              ref.read(featureProductViewModelProvider(widget.id).notifier)
                  .getAllRequestedFeatured();
            },
          ),
        ],
      ),

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
                      style: TextStyle(fontSize: 18.sp, color: Colors.grey),
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
                      style: TextStyle(fontSize: 18.sp, color: Colors.grey),
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
                      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
                      child: ListTile(
                          leading: (featuredProduct.product?.images != null &&
                              featuredProduct.product!.images!.isNotEmpty &&
                              featuredProduct.product?.images!.first.imageUrl != null)
                              ? Image.network(
                            featuredProduct.product!.images!.first.imageUrl!,
                            fit: BoxFit.cover,
                            width: 50.w,
                            height: 50.h,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error);
                            },
                          )
                              : const Icon(Icons.image_not_supported),
                          title: Text(
                            featuredProduct.product?.name ?? "Unknown",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
                      Icon(Icons.error_outline, color: Colors.red, size: 48.h),
                      SizedBox(height: 16.h),
                      Text(
                        "Error loading featured product requests: $err",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red),
                      ),
                      SizedBox(height: 16.h),
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
        padding:  EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              routesName.activefeature,
              arguments: widget.id,//send userId
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Appcolors.baseColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.0.r),
            ),
            padding: EdgeInsets.symmetric(vertical: 12.h),
          ),
          child:  Text(
            "Featured Products",
            style: TextStyle(
              color: Appcolors.whiteSmoke,
              fontWeight: FontWeight.bold,
              fontSize: 15.sp,
            ),
          ),
        ),
      ),
    );
  }
}