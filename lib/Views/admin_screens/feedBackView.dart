import 'package:ecommercefrontend/View_Model/SharedViewModels/feedbackViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/utils/colors.dart';
import '../shared/widgets/loadingState.dart';

class Feedbackview extends ConsumerStatefulWidget {
  const Feedbackview({super.key});

  @override
  ConsumerState<Feedbackview> createState() => _FeedbackviewState();
}

class _FeedbackviewState extends ConsumerState<Feedbackview> {


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(feedbackVMProvider.notifier).getFeedback();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reset user list when coming back to this view
    Future.microtask(() async{
      await ref.read(feedbackVMProvider.notifier).getFeedback();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer(
        builder: (context, ref, child) {
          final feedbacks = ref.watch(feedbackVMProvider);
          return feedbacks.when(
            loading: () => const Column(
              children: [
                ShimmerListTile(),
                ShimmerListTile(),
                ShimmerListTile(),
                ShimmerListTile(),
                ShimmerListTile(),
              ],
            ),
            data: (feedback) {
              if (feedback.isEmpty) {
                return Center(child: Text("No Feedbacks yet!"));
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: feedback.length,
                itemBuilder: (context, index) {
                  final feed = feedback[index];
                  return Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.feedback_outlined,color: Appcolors.baseColor,size: 18,),
                          title: Text("${feed.email}",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16.sp),),
                          subtitle: Text("${feed.comment}",style:  TextStyle(fontWeight: FontWeight.w300,fontSize: 14.sp)),
                        ),

                        Divider()
                      ],
                    );

                },
              );
            },
            error: (err, stack) => Center(child: Text('Error: $err')),
          );
        },
      ),
    );
  }
}
