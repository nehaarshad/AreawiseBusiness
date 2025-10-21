import 'package:ecommercefrontend/Views/shared/widgets/buttons.dart';
import 'package:ecommercefrontend/core/utils/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../View_Model/SharedViewModels/forgetKeyViewModel.dart';
import '../../../core/utils/notifyUtils.dart';

class Forgetpasswordview extends ConsumerStatefulWidget {
  const Forgetpasswordview({super.key});

  @override
  ConsumerState<Forgetpasswordview> createState() => _ForgetpasswordviewState();
}

class _ForgetpasswordviewState extends ConsumerState<Forgetpasswordview> {

  ValueNotifier<bool> pswrd = ValueNotifier<bool>(true);
  ValueNotifier<bool> cpswrd = ValueNotifier<bool>(true);
  final formkey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();


  FocusNode email = FocusNode();
  FocusNode password = FocusNode();
  FocusNode confirmPassword = FocusNode();
  

  // Dispose method
  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailController.dispose();

    email.dispose();
    password.dispose();
    confirmPassword.dispose();
  }


  @override
  Widget build(BuildContext context) {

    final model = ref.read(forgetKeyVMProvider.notifier);
    
    return Scaffold(
      appBar: AppBar(),
      body:  SingleChildScrollView(
        child: Form(
            key: formkey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0.w,),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
        
                children: [
                  Text("Forgot password",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20.sp),),
                  SizedBox(height: 5.h,),
                  Text("Create a new password. Ensure it differs from previous ones for security",style:  TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey,),),
                  SizedBox(height: 30.h,),
                  Text(" Your Email",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16.sp),),
                  SizedBox(height: 5.h,),
                  // Email field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    focusNode: email,
                    decoration: InputDecoration(
                      hintText: "Enter your email",
                      hintStyle: TextStyle(color: Colors.grey,fontSize: 14.sp,),
                      prefixIcon: Icon(Icons.email_outlined),
                      
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0.r),
                        
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter email";
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) {
                      Utils.focusarea(context, email, password);
                    },
                  ),
                  SizedBox(height: 15.h,),
                  Text(" Password",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16.sp),),
                  SizedBox(height: 5.h,),
                  // Password field
                  ValueListenableBuilder(
                    valueListenable: pswrd,
                    builder: (context, value, child) {
                      return TextFormField(
                        controller: _passwordController,
                        obscureText: pswrd.value,
                        obscuringCharacter: "*",
                        focusNode: password,
                        decoration: InputDecoration(
                          hintText: "Enter your new password",
                          hintStyle: TextStyle(color: Colors.grey,fontSize: 14.sp,),
                          prefixIcon: Icon(Icons.lock_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0.r),
                          ),
                          suffixIcon: InkWell(
                            onTap: () {
                              pswrd.value = !pswrd.value;
                            },
                            child: Icon(
                              pswrd.value
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter password";
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) {
                          Utils.focusarea(context, password, confirmPassword);
                        },
                      );
                    },
                  ),
                  SizedBox(height: 15.h,),
                  Text(" Confirm Password",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16.sp),),
                  SizedBox(height: 5.h,),
                  ValueListenableBuilder(
                    valueListenable: cpswrd,
                    builder: (context, value, child) {
                      return TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: cpswrd.value,
                        obscuringCharacter: "*",
                        focusNode: confirmPassword,
                        decoration: InputDecoration(
                          hintText: "Re-enter password",
                          hintStyle: TextStyle(color: Colors.grey,fontSize: 14.sp,),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0.r),
                          ),
                          prefixIcon: Icon(Icons.lock_outline),
                          suffixIcon: InkWell(
                            onTap: () {
                              cpswrd.value = !cpswrd.value;
                            },
                            child: Icon(
                              cpswrd.value
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Confirm Password field is missing";
                          }
                          return null;
                        },
                      );
                    },
                  ),
        
                  SizedBox(height: 20.h,),
                   CustomButton(text: "Update Password", onPressed: (){
                  final data={
                  'email':_emailController.text.trim().toString() ,
                  'password':_passwordController.text.trim().toString()
                  };
                  ref.read(forgetKeyVMProvider.notifier).forgetKey(data, context);
        
        
                  })
        
        
                ],
              ),
            ),
          ),
      ),

    );
  }
}
