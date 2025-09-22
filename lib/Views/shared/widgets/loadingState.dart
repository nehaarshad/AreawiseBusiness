import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class ShimmerListTile extends StatelessWidget {
  final bool hasAvatar;
  final bool hasSubtitle;

  const ShimmerListTile({
    super.key,
    this.hasAvatar = true,
    this.hasSubtitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListTile(
        leading: hasAvatar
            ? const CircleAvatar(backgroundColor: Colors.white)
            : null,
        title: Container(
          width: double.infinity,
          height: 16,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        subtitle: hasSubtitle
            ? Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Container(
            width: double.infinity,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.white54,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        )
            : null,
      ),
    );
  }
}
