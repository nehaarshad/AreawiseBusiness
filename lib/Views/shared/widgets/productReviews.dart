import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../View_Model/SharedViewModels/ReviewsViewModel.dart';
import '../../../core/utils/colors.dart';
import 'expandedReviewWidget.dart';
import 'loadingState.dart';


// ProductReviews widget
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
  int _selectedRating = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reviewsModelProvider(widget.userId.toString()).notifier)
          .getProductReviews(widget.productId.toString());
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _showReviewDialog() {
    setState(() {
      _selectedRating = 0;
      _commentController.clear();
    });

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add Your Review'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          Icons.star,
                          color: _selectedRating > index
                              ? Appcolors.baseColor
                              : Colors.grey,
                          size: 25.h,
                        ),
                        onPressed: () {
                          setState(() {
                            _selectedRating = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                ),
                 SizedBox(height: 16.h),
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
            actions: [
              
              TextButton(
                onPressed: () async {
                  print('Post button pressed');
                  print('Rating: $_selectedRating, Comment: ${_commentController.text}');

                  // Validate input first
                  if (_selectedRating == 0 || _commentController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please add both rating and comment')),
                    );
                    return;
                  }

                  try {
                    Navigator.pop(context);

                    await ref.read(reviewsModelProvider(widget.userId.toString()).notifier)
                        .addProductReviews(
                      widget.userId.toString(),
                      widget.productId,
                      _selectedRating,
                      _commentController.text.trim(),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Review posted successfully')),
                    );
                  } catch (e) {
                    print('Error posting review: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to post review: $e')),
                    );
                  }
                },
                child: Text('Post',style: TextStyle(color: Appcolors.baseColor,fontSize: 18.sp,fontWeight: FontWeight.bold),),
              ),
            ],
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
                onPressed: _showReviewDialog,
                child: Text("Add Review",style: TextStyle(color: Appcolors.baseColor,fontSize: 13.sp),))

          ],
        ),
        const Divider(),
        reviewsAsync.when(
          loading: () => const ShimmerListTile(),

          error: (error, stack) => Center(child: Text('Error: $error')),
    data: (comments) {
    if (comments.isEmpty) {
    return  Center(
    child: Padding(
    padding: EdgeInsets.symmetric(vertical: 20.0.h),
    child: Text(
    'No reviews yet. Be the first to review!',
    style: TextStyle(color: Colors.grey),
    ),
    ),
    );
    }


    return ExpandedReviewsWidget(
      comments: comments,
      userId: widget.userId,
      productId: widget.productId,
    );

          },
        ),
      ],
    );
  }
}

