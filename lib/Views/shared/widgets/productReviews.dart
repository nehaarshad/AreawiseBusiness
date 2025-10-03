import 'package:ecommercefrontend/core/utils/dialogueBox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../View_Model/SharedViewModels/ReviewsViewModel.dart';
import '../../../core/utils/colors.dart';
import '../../../states/reviewStates.dart';
import 'expandedReviewWidget.dart';
import 'loadingState.dart';

class ProductReviews extends ConsumerStatefulWidget {
  final int productId;
  final int userId;

  const ProductReviews({
    required this.productId,
    required this.userId,
    Key? key
  }) : super(key: key);

  @override
  ConsumerState<ProductReviews> createState() => _ProductReviewsState();
}

class _ProductReviewsState extends ConsumerState<ProductReviews> {

  final TextEditingController _commentController = TextEditingController();
  late ValueNotifier<int> _selectedRating;

  @override
  void initState() {
    super.initState();
    _selectedRating = ValueNotifier<int>(0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reviewsModelProvider(widget.userId.toString()).notifier)
          .getProductReviews(widget.productId.toString());
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    _selectedRating.dispose();
    super.dispose();
  }

  void _showReviewDialog() {
    _commentController.clear();
    _selectedRating.value=0;


    showDialog(
      context: context,
      builder: (context) => ValueListenableBuilder<int>(
        valueListenable: _selectedRating,
        builder: (context, rating, child) {
          return Consumer(
            builder: (context, ref, child) {
              final currentState = ref.watch(
                  reviewsModelProvider(widget.userId.toString()));

              return AlertDialog(
                title: const Text('Add Your Review'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(5, (index) {
                            return IconButton(
                              icon: Icon(
                                Icons.star,
                                color: rating > index
                                    ? Appcolors.baseColor
                                    : Colors.grey,
                                size: 25.h,
                              ),
                              onPressed: () {
                                _selectedRating.value = index + 1;
                              },
                            );
                          }),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      if(currentState.images.isEmpty)
                        InkWell(
                          onTap: () {
                            ref
                                .read(reviewsModelProvider(widget.userId.toString()).notifier)
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
                                Icon(Icons.upload, size: 50.h, color: Colors.grey[600]),
                                const SizedBox(height: 8),
                                Text("Tap to upload image",
                                  style: TextStyle(color: Colors.grey[600]),),
                              ],
                            ),
                            height: 100.h,
                            width: 400.w,
                          ),
                        ),
                      if (currentState.images.isNotEmpty) ...[
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
                                            .read(reviewsModelProvider(
                                            widget.userId.toString()).notifier)
                                            .removeImage(index);
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                      SizedBox(height: 12.h),
                      TextField(
                        controller: _commentController,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          ref.read(reviewsModelProvider(widget.userId.toString()).notifier).resetState();
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          if (rating == 0 || _commentController.text.trim().isEmpty) {
                            DialogUtils.showErrorDialog(
                                context, "Please add both rating and comment");
                            return;
                          }

                          try {
                            final navigator = Navigator.of(context);
                            final scaffoldMessenger = ScaffoldMessenger.of(context);

                            navigator.pop();

                            await ref.read(
                                reviewsModelProvider(widget.userId.toString()).notifier)
                                .addProductReviews(
                              widget.userId.toString(),
                              widget.productId,
                              rating,
                              _commentController.text.trim(),
                            );
                          } catch (e) {
                            if (context.mounted) {
                              DialogUtils.showErrorDialog(
                                  context, "Failed to post review");
                            }
                          }
                        },
                        child: Text(
                          'Add',
                          style: TextStyle(
                              color: Appcolors.baseColor,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reviewsAsync = ref.watch(reviewsModelProvider(widget.userId.toString()));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Reviews",
              style: TextStyle(
                color: Appcolors.baseColorLight30,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextButton(
              // FIXED: Pass the current state to the dialog
              onPressed: () => _showReviewDialog(),
              child: Text(
                "Add Review",
                style: TextStyle(
                    color: Appcolors.baseColor,
                    fontSize: 13.sp
                ),
              ),
            )
          ],
        ),
        const Divider(),
        reviewsAsync.isLoading
            ?
        const ShimmerListTile()
            :
        reviewsAsync.reviews.isEmpty
            ?
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0.h),
            child: const Text(
              'No reviews yet. Be the first to review!',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        )
            :
        ExpandedReviewsWidget(
          comments: reviewsAsync.reviews,
          userId: widget.userId,
          productId: widget.productId,
        )
      ],
    );
  }
}