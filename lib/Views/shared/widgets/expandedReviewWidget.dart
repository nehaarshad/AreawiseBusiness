import 'dart:math';

import 'package:flutter/material.dart';

import '../../../View_Model/SharedViewModels/reviewItems.dart';
import '../../../models/reviewsModel.dart';

class ExpandedReviewsWidget extends StatefulWidget {
  final List<Reviews?> comments;
  final int userId;
  final int productId;

  const ExpandedReviewsWidget({
    required this.comments,
    required this.userId,
    required this.productId,
    Key? key,
  }) : super(key: key);

  @override
  State<ExpandedReviewsWidget> createState() => _ExpandedReviewsWidgetState();
}

class _ExpandedReviewsWidgetState extends State<ExpandedReviewsWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final hasMoreReviews = widget.comments.length > 2;

    return Column(
      children: [
        // Always show first 2 reviews or all if expanded
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _expanded ? widget.comments.length : min(2, widget.comments.length),
          itemBuilder: (context, index) {
            final comment = widget.comments[index];
            if (comment == null) return const SizedBox.shrink();

            return ReviewItem(
              review: comment,
              userId: widget.userId,
              productId: widget.productId,
            );
          },
        ),

        // Show expand/collapse button if there are more than 2 reviews
        if (hasMoreReviews)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: InkWell(
              onTap: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _expanded
                          ? 'Show Less'
                          : 'Show All Reviews (${widget.comments.length})',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}