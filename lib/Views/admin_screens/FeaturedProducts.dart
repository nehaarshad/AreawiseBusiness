import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../View_Model/SellerViewModels/createFeatureProductViewModel.dart';
import '../../View_Model/SharedViewModels/featuredProductViewModel.dart';
import '../shared/widgets/SetDateTime.dart';
import '../../core/utils/colors.dart';
import '../shared/widgets/loadingState.dart';

class Featuredproducts extends ConsumerStatefulWidget {
  String id;
  Featuredproducts({super.key, required this.id});

  @override
  ConsumerState<Featuredproducts> createState() => _FeaturedproductState();
}

class _FeaturedproductState extends ConsumerState<Featuredproducts> {
  final key = GlobalKey<FormState>();
  DateTime? selectedDate;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_)async {
      await ref.read(featureProductViewModelProvider(widget.id).notifier)
          .getAllFeaturedProducts('All');
    });
  }


  Future<void> updateFeatureStatus(String featureId, String userId,
      String status, DateTime expireAt) async {
    // Convert DateTime to ISO string format for proper serialization
    final data = {
      "status": status,
      "expire_at": expireAt.toIso8601String() // Convert DateTime to ISO string
    };

    await ref.read(createfeatureProductViewModelProvider(widget.id).notifier)
        .updateFeatureProduct(featureId, userId, data, context);
  }

  Future<void> featureProduct(BuildContext context, String featureId,
      String userId) async
  {
    selectedDate = null;
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
            builder: (stateContext, setDialogState) {
              return AlertDialog(
                title: const Text("Set Expiration Time"),
                content: Form(
                  key: key,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                       SizedBox(height: 16.h),
                      GestureDetector(
                        onTap: () async {
                          final DateTime? dateTime = await setDateTime(
                              stateContext);
                          if (dateTime != null) {
                            setDialogState(() {
                              selectedDate =
                                  dateTime; // Update selectedDate in dialog state
                            });
                            await ref.read(
                                createfeatureProductViewModelProvider(widget.id).notifier)
                                .selectExpirationDateTime(dateTime);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 16.h),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(selectedDate != null
                                  ? "${selectedDate!.day}/${selectedDate!
                                  .month}/${selectedDate!
                                  .year} at ${selectedDate!
                                  .hour}:${selectedDate!.minute.toString()
                                  .padLeft(2, '0')}"
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
                          Navigator.pop(dialogContext, false); // Cancel
                        },
                        child: const Text("Cancel", style: TextStyle(
                            color: Colors.grey)),
                      ),
                      TextButton(
                        onPressed: () async {
                          if (selectedDate != null) {
                            await updateFeatureStatus(
                                featureId, userId, 'Featured', selectedDate!);
                            Navigator.pop(dialogContext, true);
                          } else {
                            // Show error that date is required
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(
                                    'Please select an expiration date'))
                            );
                          }
                        },
                        child: const Text("Update", style: TextStyle(
                            color: Appcolors.baseColor)),
                      ),
                    ],
                  ),
                ],
              );
            }
        );
      },
    );

    // If result is true, refresh only the featured products list
    if (result == true) {
    await  ref.read(featureProductViewModelProvider(widget.id).notifier)
          .getFeaturedProducts('All');
    }
  }

  @override
  Widget build(BuildContext context) {
    final featureState = ref.watch(featureProductViewModelProvider(widget.id));

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Featured Products"),
        actions: [
          TextButton(
            child: const Text("Back",style: TextStyle(color:Appcolors.baseColor),),
            onPressed: ()async{
              await  ref.read(featureProductViewModelProvider(widget.id).notifier)
                  .getAllRequestedFeatured();
              Navigator.pop(context);
              // Navigator.pushNamed(context, routesName.requestfeature,arguments: widget.id);
            }
          ),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: featureState.when(
              loading: () => const Column(
                children: [
                  ShimmerListTile(),
                  ShimmerListTile(),
                  ShimmerListTile(),
                  ShimmerListTile(),
                  ShimmerListTile(),
                ],
              ),
              data: (featuredProducts) {
                if (featuredProducts.isEmpty) {
                  return Center(
                    child: Text(
                      "No featured products yet",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                // Filter to show only products with 'Featured' status
                final activeFeatures = featuredProducts
                    .where((product) => product?.status == 'Featured')
                    .toList();

                if (activeFeatures.isEmpty) {
                  return Center(
                    child: Text(
                      "No active featured products yet",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: activeFeatures.length,
                  itemBuilder: (context, index) {
                    final featuredProduct = activeFeatures[index];
                    if (featuredProduct == null) return SizedBox.shrink();

                    // Check if the product has expired
                    bool isExpired = false;
                    if (featuredProduct.expireAt != null) {
                      final expireDate = DateTime.parse(
                          featuredProduct.expireAt!);
                      isExpired = expireDate.isBefore(DateTime.now());
                    }

                    return Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                              leading: (featuredProduct.product?.images !=
                                  null &&
                                  featuredProduct.product!.images!.isNotEmpty &&
                                  featuredProduct.product?.images!.first
                                      .imageUrl != null)
                                  ? CachedNetworkImage(
                               imageUrl:  featuredProduct.product!.images!.first
                                    .imageUrl!,
                                fit: BoxFit.cover,
                                width: 50.w,
                                height: 50.h,
                                errorWidget: (context, error, stackTrace) {
                                  return const Icon(Icons.error);
                                },
                              )
                                  : const Icon(Icons.image_not_supported),
                              title:  Text(
                                featuredProduct.product?.name ?? "Unknown",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit, color: Appcolors.baseColor,),
                                    onPressed: () async {
                                      if (featuredProduct.id != null &&
                                          featuredProduct.userID != null) {
                                        await featureProduct(context,
                                            featuredProduct.id.toString(),
                                            featuredProduct.userID.toString());
                                      }
                                    },
                                  ),

                                ],
                              )
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Expires: ", style: TextStyle(
                                  color: Appcolors.baseColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500)),
                              Text(
                                "${_formatDate(featuredProduct.expireAt)}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300
                                ),
                              ),

                            ],
                          ),
                          SizedBox(height: 8.h),
                        ],
                      ),
                    );
                  },
                );
              },
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? timestamp) {
    if (timestamp == null) return '';
    try {
      final dateTime = DateTime.parse(timestamp).toLocal();
      final hour = dateTime.hour;
      final minute = dateTime.minute.toString().padLeft(2, '0');
      final period = hour < 12 ? 'AM' : 'PM';
      final hour12;
      if (hour == 0) {
        hour12 = 12; // midnight (0:00) → 12 AM
      } else if (hour > 12) {
        hour12 = hour - 12; // PM hours
      } else {
        hour12 = hour; // AM hours (1-12)
      }

      return '${dateTime.day}-${dateTime.month}-${dateTime
          .year}  $hour12:$minute $period';
    } catch (_) {
      return '';
    }
  }
}