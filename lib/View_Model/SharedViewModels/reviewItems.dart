import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Views/shared/widgets/profileImageWidget.dart';
import '../../models/reviewsModel.dart';
import 'ReviewsViewModel.dart';


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
      color: Appcolors.whiteColor,
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
                      backgroundColor: Colors.blue,
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
                              color: index < review.rating! ? Colors.blue : Colors.grey,
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
            const SizedBox(height: 8),
            Text(review.comment!),

          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref) {
    final commentController = TextEditingController(text: review.comment);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Edit Your Review'),
            content: TextField(
              controller: commentController,
              decoration: const InputDecoration(
                hintText: 'Write your review here...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),

            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  // Update the review
                  ref.read(reviewsModelProvider(userId.toString()).notifier).updateProductReviews(
                    review.id.toString(),
                    productId.toString(),
                    commentController.text.trim(),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Update'),
              ),
            ],
          );
        },
      ),
    );
  }


  String formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return '${date.day}/${date.month}/${date.year}';
  }
}