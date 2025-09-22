import 'package:ecommercefrontend/View_Model/UserProfile/EditProfileViewModel.dart';
import 'package:ecommercefrontend/core/utils/textStyles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/utils/notifyUtils.dart';
import '../../../models/UserDetailModel.dart';

class Changepasswordview extends ConsumerStatefulWidget {
  String id;
   Changepasswordview({required this.id});

  @override
  ConsumerState<Changepasswordview> createState() => _ChangepasswordviewState();
}

class _ChangepasswordviewState extends ConsumerState<Changepasswordview> {
  ValueNotifier<bool> oldPswrd = ValueNotifier<bool>(true);
  ValueNotifier<bool> pswrd = ValueNotifier<bool>(true);
  ValueNotifier<bool> cpswrd = ValueNotifier<bool>(true);
  final formkey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  FocusNode oldPassword = FocusNode();
  FocusNode password = FocusNode();
  FocusNode confirmPassword = FocusNode();

  // Dispose method
  @override
  void dispose() {
    super.dispose();
    _oldPasswordController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    password.dispose();
    confirmPassword.dispose();
    oldPassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.read(editProfileViewModelProvider(widget.id.toString()));
    final model = ref.read(editProfileViewModelProvider(widget.id.toString()).notifier);

    void onSubmit(EditProfileViewModel viewmodel,BuildContext context) {
      if (formkey.currentState!.validate()) {
        if (_passwordController.text.trim().length < 8) {
          Utils.flushBarErrorMessage(
            "Please Enter 8 digit Password",
            context,
          );
        }
        else if (_passwordController.text.trim() != _confirmPasswordController.text.trim()) {
          Utils.flushBarErrorMessage(
            "Passwords do not match",
            context,
          );
        }

        else {
          Map<String, dynamic> data = {
            'oldPassword': _oldPasswordController.text.trim().toString(),
            'newPassword': _passwordController.text.toString().trim(),
          };
          if(kDebugMode){

            print("oldPassword:  ${data['oldPassword']} with type:  ${data['oldPassword'].runtimeType}");
            print("newPassword:  ${data['newPassword']} with type:  ${data['newPassword'].runtimeType}");
          }

          viewmodel.ChangePassword(data,context);
        }
      }
    }
    Widget changeButton(
        AsyncValue<UserDetailModel?> state,
        EditProfileViewModel viewModel,
        BuildContext context,
        ) {
      return TextButton(

        onPressed: state.isLoading ? null : () => onSubmit(viewModel, context),
        child:
        state.isLoading
            ? const CircularProgressIndicator()
            : const Text("Save"),
      );
    }

    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Center(child: Text('Reset Password',style: AppTextStyles.headline,)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.symmetric(vertical: 50.h, horizontal: 20.w),
            child: Form(
              key: formkey,

              child: Column(
                spacing: 10.h,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  ValueListenableBuilder(
                    valueListenable: oldPswrd,
                    builder: (context, value, child) {
                      return TextFormField(
                        controller: _oldPasswordController,
                        obscureText: oldPswrd.value,
                        obscuringCharacter: "*",
                        focusNode: oldPassword,
                        decoration: InputDecoration(
                          hintText: "Old Password",
                          prefixIcon: Icon(Icons.lock_outline),
                          suffixIcon: InkWell(
                            onTap: () {
                              oldPswrd.value = !oldPswrd.value;
                            },
                            child: Icon(
                              oldPswrd.value
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
                          Utils.focusarea(context, oldPassword, password);
                        },
                      );
                    },
                  ),
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
                          hintText: "Password",
                          prefixIcon: Icon(Icons.lock_outline),
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
                  ValueListenableBuilder(
                    valueListenable: cpswrd,
                    builder: (context, value, child) {
                      return TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: cpswrd.value,
                        obscuringCharacter: "*",
                        focusNode: confirmPassword,
                        decoration: InputDecoration(
                          hintText: "Confirm Password",
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

                  SizedBox(height: 50.h),
                  // SignUp button
                  Consumer(
                    builder: (context, ref, child) {
                      return  changeButton(state,model,context);


                    },
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
