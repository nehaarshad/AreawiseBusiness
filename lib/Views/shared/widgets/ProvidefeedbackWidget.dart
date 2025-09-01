import 'package:ecommercefrontend/View_Model/SharedViewModels/feedbackViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/utils/colors.dart';

class submitFeedbackWidget extends ConsumerStatefulWidget {

  const submitFeedbackWidget({super.key});

  @override
  ConsumerState<submitFeedbackWidget> createState() => _submitFeedbackWidgetState();
}

class _submitFeedbackWidgetState extends ConsumerState<submitFeedbackWidget> {

  final formkey = GlobalKey<FormState>();
  TextEditingController email=TextEditingController();
  TextEditingController comment=TextEditingController();

  @override
  void dispose() {
    email.dispose();
    comment.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return  Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0.h),
      child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Your email address",
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Appcolors.baseColor,
                        width: 2.0,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter email";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16.0), // Space between fields

                TextFormField(
                  controller: comment,
                  decoration: InputDecoration(
                    hintText: "Write a message here...",
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,

                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Appcolors.baseColor,
                        width: 2.0,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Required";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 120.w,
                      height: 40.h,
                      child: Center(
                        child: ElevatedButton(
                          onPressed:() async {
                            if (formkey.currentState!.validate()) {
                              await ref.read(feedbackVMProvider.notifier).submitResponse(
                                  email.text, comment.text, context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Appcolors.baseColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0.r),
                            ),
                          ),
                          child:  Text(
                            "Submit",
                            style: TextStyle(
                              color: Appcolors.whiteSmoke,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }
}

