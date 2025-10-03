import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommercefrontend/View_Model/SharedViewModels/updateReviewViewModel.dart';
import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/utils/dialogueBox.dart';
import 'profileImageWidget.dart';
import '../../../models/reviewsModel.dart';
import '../../../View_Model/SharedViewModels/ReviewsViewModel.dart';


class ReviewItem extends ConsumerWidget {
  final Reviews review;
  final int userId;
  final int productId;

  const ReviewItem({
    required this.review,
    required this.userId,
    required this.productId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCurrentUserReview = review.userId == userId;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),

      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Appcolors.baseColorLight30,
                      child:  ProfileImageWidget(user:  review.user!, height: 50, width: 50),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              review.user!.username!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 5,),
                            if (review.createdAt != null)
                              Text(
                                formatDate(review.createdAt!),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              Icons.star,
                              color: index < review.rating! ? Appcolors.baseColorLight30 : Colors.grey,
                              size: 16,
                            );
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
                if (isCurrentUserReview)
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, size: 18),
                        onPressed: () {
                          _showEditDialog(context, ref);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 18),
                        onPressed: () {
                          ref.read(reviewsModelProvider(userId.toString()).notifier).deleteProductReview(
                            review.id.toString(),
                            productId.toString(),
                          );
                        },
                      ),
                    ],
                  ),
              ],
            ),
             SizedBox(height: 8.h),
            Text(review.comment!),
             SizedBox(height: 8.h,),
           if(review.images != null && review.images!.isNotEmpty )
             SizedBox(
               height: 150.h,
               child: ListView.builder(
                 scrollDirection: Axis.horizontal,
                 itemCount: review.images!.length,
                 itemBuilder: (context, index) {
                   return Stack(
                     children: [
                       Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Container(
                           width: 130.w, // Define explicit width
                           height: 150.h, // Define explicit height
                           decoration: BoxDecoration(
                             border: Border.all(color: Colors.grey),
                             borderRadius: BorderRadius.circular(8.r),
                           ),
                           child: ClipRRect(
                             borderRadius: BorderRadius.circular(8.r),
                             child: CachedNetworkImage(
                              imageUrl:  review.images![index]!.imageUrl!,
                               fit: BoxFit.cover, // Important for proper display
                             ),
                           ),
                         ),
                       ),

                     ],
                   );
                 },
               ),
             ),

          ],
        ),
      ),
    );
  }


  String formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showEditDialog(BuildContext context, WidgetRef ref) {
    final commentController = TextEditingController(text: review.comment);

    // Initialize the edit state with existing review images
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(updateReviewsModelProvider(userId.toString()).notifier)
          .initializeExistingImages(review.images ?? []);
    });

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Consumer(
            builder: (context, ref, child) {
              final currentState = ref.watch(updateReviewsModelProvider(userId.toString()));

              return AlertDialog(
                title: const Text('Edit Your Review'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (currentState.images.isNotEmpty) ...[

                        SizedBox(height: 8.h),
                        SizedBox(
                          height: 150.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: currentState.images.length,
                            itemBuilder: (context, index) {
                              return Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 130.w,
                                      height: 150.h,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8.r),
                                        child: Image.file(
                                           currentState.images[index],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.remove_circle,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        ref
                                            .read(updateReviewsModelProvider(userId.toString()).notifier)
                                            .removeImage(index);
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 12.h),
                      ],

                      if (currentState.images.length  < 3)
                        InkWell(
                          onTap: () {
                            ref
                                .read(updateReviewsModelProvider(userId.toString()).notifier)
                                .pickImages(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.0.r),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.upload, size: 40.h, color: Colors.grey[600]),
                                const SizedBox(height: 8),
                                Text(
                                  "Add more images",
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            height: 80.h,
                            width: double.infinity,
                          ),
                        ),

                      SizedBox(height: 12.h),
                      TextField(
                        controller: commentController,
                        decoration: const InputDecoration(
                          hintText: 'Write your review here...',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ref.read(reviewsModelProvider(userId.toString()).notifier).resetState();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (commentController.text.trim().isEmpty) {
                        DialogUtils.showErrorDialog(context, "Comment cannot be empty");
                        return;
                      }

                      try {
                        Navigator.pop(context);

                        await ref.read(updateReviewsModelProvider(userId.toString()).notifier)
                            .updateProductReviews(
                          review.id.toString(),
                          productId.toString(),
                          commentController.text.trim(),
                        );
                      } catch (e) {
                        if (context.mounted) {
                          DialogUtils.showErrorDialog(context, "Failed to update review");
                        }
                      }
                    },
                    child: const Text('Update'),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}