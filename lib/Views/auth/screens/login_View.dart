import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:ecommercefrontend/core/utils/routes/routes_names.dart';
import 'package:ecommercefrontend/core/utils/textStyles.dart';
import 'package:ecommercefrontend/core/utils/notifyUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../View_Model/auth/login_viewModel.dart';
import '../../shared/widgets/buttons.dart';

class login_view extends ConsumerStatefulWidget {
  @override
  ConsumerState<login_view> createState() => _login_viewState();
}

class _login_viewState extends ConsumerState<login_view> {
  ValueNotifier<bool> _obscureText = ValueNotifier<bool>(true);
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  FocusNode email = FocusNode();
  FocusNode password = FocusNode();

  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginViewModel = ref.read(loginProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Appcolors.baseColor,
        title:Padding(
          padding:  EdgeInsets.only(top: 25.0.h),
          child: Text("SignIn",style: TextStyle(color: Appcolors.whiteSmoke,fontSize: 25.sp,fontWeight: FontWeight.bold),
          ),
        )
      ),
      backgroundColor: Appcolors.baseColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40.h,),
            child: Container(
              decoration: BoxDecoration(
                color: Appcolors.whiteSmoke,
                borderRadius: BorderRadius.circular(15.r),
                border: Border.all(  // Use Border.all instead of boxShadow for borders
                  color: Appcolors.baseColor,
                  width: 1.0,  // Don't forget to specify border width
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 30.0.h,left: 22.w,right: 22.w,bottom: 200.h),
                child: Column(
                  spacing: 10.h,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("BizAroundU",style: TextStyle(fontWeight: FontWeight.bold,color: Appcolors.baseColor,fontSize: 20.sp),),

                    Text("Continue to sign in!",
                      style: TextStyle(fontWeight: FontWeight.w400,color: Appcolors.baseColorLight30,fontSize: 15.sp),),
                    SizedBox(height: 40.h,),
                    TextFormField(
                      controller: _usernameController,
                      focusNode: email,
                      decoration: InputDecoration(
                        hintText: "Username",
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      onFieldSubmitted: (value) {
                        Utils.focusarea(context, email, password);
                      },
                    ),
                    ValueListenableBuilder(
                      valueListenable: _obscureText,
                      builder: (context, value, child) {
                        return TextFormField(
                          controller: _passwordController,
                          obscureText: _obscureText.value,
                          obscuringCharacter: "*",
                          focusNode: password,
                          decoration: InputDecoration(
                            hintText: "Password",
                            prefixIcon: Icon(Icons.lock_outline),
                            suffixIcon: InkWell(
                              onTap: () {
                                _obscureText.value = !_obscureText.value;
                              },
                              child: Icon(
                                _obscureText.value
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                      TextButton(onPressed: (){
                        Navigator.pushNamed(context, routesName.forget);
                      }, child: Text("Forget Password?"))
                    ],),
                    SizedBox(height: 5.h),
                    Consumer(
                      builder: (context, ref, child) {
                        final loading = ref.watch(loginProvider);
                        return CustomButton(
                          text: "Sign In",
                          onPressed: () {
                            if (_usernameController.text.isEmpty) {
                              Utils.flushBarErrorMessage(
                                "Please Enter Username",
                                context,
                              );
                            } else if (_passwordController.text.trim().isEmpty) {
                              Utils.flushBarErrorMessage(
                                "Please Enter Password",
                                context,
                              );
                            } else if (_passwordController.text.trim().length < 8) {
                              Utils.flushBarErrorMessage(
                                "Please Enter 8 digit Password",
                                context,
                              );
                            } else {
                              Map data = {
                                'username': _usernameController.text.trim().toString(),
                                'password': _passwordController.text.trim().toString(),
                              };
                              loginViewModel.loginApi(data, context);
                            }
                          },
                          isLoading: loading,
                        );
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account?",style: TextStyle(fontSize: 15.sp),),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, routesName.signUp);
                            },
                            child: Text(
                              " Sign Up",
                              style: TextStyle(
                                  color: Appcolors.baseColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.sp,

                              ),
                            ),
                          ),
                        ],
                      ),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
