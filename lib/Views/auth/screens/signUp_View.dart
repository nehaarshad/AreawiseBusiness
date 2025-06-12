import 'package:ecommercefrontend/core/utils/textStyles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../View_Model/auth/SignUp_viewModel.dart';
import '../../../core/utils/routes/routes_names.dart';
import '../../../core/utils/utils.dart';
import '../../shared/widgets/buttons.dart';
import '../../../core/utils/colors.dart';

class signUp_View extends ConsumerStatefulWidget {
  const signUp_View({super.key});

  @override
  ConsumerState<signUp_View> createState() => _signUp_ViewState();
}

class _signUp_ViewState extends ConsumerState<signUp_View> {
  ValueNotifier<bool> pswrd = ValueNotifier<bool>(true);
  ValueNotifier<bool> cpswrd = ValueNotifier<bool>(true);
  final formkey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();

  FocusNode username = FocusNode();
  FocusNode email = FocusNode();
  FocusNode password = FocusNode();
  FocusNode confirmPassword = FocusNode();
  FocusNode contactNumber = FocusNode();

  String? _selectedRole;

  // Dispose method
  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailController.dispose();
    _contactNumberController.dispose();

    username.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    contactNumber.dispose();
  }

  Widget buildRoleDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: _selectedRole,
          decoration: InputDecoration(
            hintText: "Select Role",
            prefixIcon: Icon(Icons.person_outline),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please select a role";
            }
            return null;
          },
          onChanged: (value) {
            setState(() {
              _selectedRole = value;
            });
          },
          items: const [
            DropdownMenuItem(value: "Buyer", child: Text("Buyer")),
            DropdownMenuItem(value: "Seller", child: Text("Seller")),
            DropdownMenuItem(value: "Both", child: Text("Both")),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final signUpviewmodel = ref.read(signupProvider.notifier);

    void handleSignUp() {
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
        else if (_selectedRole == null) {
          Utils.flushBarErrorMessage(
            "Please select a role",
            context,
          );
        }
        else {
          Map<String, dynamic> data = {
            'username': _usernameController.text.trim().toString(),
            'email': _emailController.text.trim().toString(),
            'contactnumber': int.parse(_contactNumberController.text.trim()),
            'password': _passwordController.text.toString().trim(),
            'role': _selectedRole!,
          };
          if(kDebugMode){

          print("useranme:  ${data['username']} with type:  ${data['username'].runtimeType}");
          print("email:  ${data['email']} with type:  ${data['email'].runtimeType}");
          print("contactnumber:  ${data['contactnumber']} with type:  ${data['contactnumber'].runtimeType}");
          print("password:  ${data['password']} with type:  ${data['password'].runtimeType}");
          print("role:  ${data['role']} with type:  ${data['role'].runtimeType}");
          }

          signUpviewmodel.SignUpApi(data, context);
        }
      }
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text('Sign Up',style: AppTextStyles.headline,)),
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
                  // Username field
                  TextFormField(
                    controller: _usernameController,
                    focusNode: username,
                    decoration: InputDecoration(
                      hintText: "Username",
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter username";
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) {
                      Utils.focusarea(context, username, email);
                    },
                  ),

                  // Email field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    focusNode: email,
                    decoration: InputDecoration(
                      hintText: "Email",
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter email";
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) {
                      Utils.focusarea(context, email, contactNumber);
                    },
                  ),

                  // Contact Number field
                  TextFormField(
                    controller: _contactNumberController,
                    keyboardType: TextInputType.number,
                    focusNode: contactNumber,
                    decoration: InputDecoration(
                      hintText: "Contact Number",
                      prefixIcon: Icon(Icons.phone),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter number";
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) {
                      Utils.focusarea(context, contactNumber, password);
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
                  buildRoleDropdown(),
                  SizedBox(height: 50.h),
                  // SignUp button
                  Consumer(
                    builder: (context, ref, child) {
                      final loading = ref.watch(signupProvider);
                      return CustomButton(
                        text: "Sign Up",
                        onPressed: handleSignUp,
                        isLoading: loading,
                      );
                    },
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding:  EdgeInsets.symmetric(
                      vertical: 2.h,
                      horizontal: 15.w,
                    ),
                    child: Row(
                      children: [
                        Text("Already have an Account?"),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, routesName.login);
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Appcolors.blueColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
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
