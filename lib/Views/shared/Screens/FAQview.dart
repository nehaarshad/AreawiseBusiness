import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/FAQwidgets.dart';
import '../widgets/ProvidefeedbackWidget.dart';

class Faqview extends ConsumerStatefulWidget {
  const Faqview({super.key});

  @override
  ConsumerState<Faqview> createState() => _FaqviewState();
}

class _FaqviewState extends ConsumerState<Faqview> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Contact Us",
          style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 18.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 15.h),
              child: submitFeedbackWidget(),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Frequently Asked Questions!',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Replace Expanded with ListView that shrinks to fit its content
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: ListView.builder(
                shrinkWrap: true, // Important: makes ListView take only the space it needs
                physics: NeverScrollableScrollPhysics(), // Disable ListView scroll, let parent handle it
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: faqItems.length,
                itemBuilder: (context, index) {
                  final faqItem = faqItems[index];

                  return Container(
                    margin: EdgeInsets.only(bottom: 8.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      childrenPadding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                      leading: Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.quiz_outlined,
                          color: Appcolors.baseColor,
                          size: 20.sp,
                        ),
                      ),
                      title: Text(
                        faqItem.question,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      trailing: AnimatedRotation(
                        turns: faqItem.isExpanded ? 0.5 : 0,
                        duration: Duration(milliseconds: 200),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      onExpansionChanged: (expanded) {
                        setState(() {
                          faqItem.isExpanded = expanded;
                        });
                      },
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              faqItem.answer,
                              style: TextStyle(
                                fontSize: 14.sp,
                                height: 1.5,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Add some bottom padding for better scroll experience
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}