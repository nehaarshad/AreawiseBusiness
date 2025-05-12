import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../View_Model/SharedViewModels/forgetKeyViewModel.dart';
import '../../../core/utils/utils.dart';

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
      body:  Form(
          key: formkey,
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                    Utils.focusarea(context, email, password);
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

                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 2,
                    horizontal: 15,
                  ),
                  child: TextButton(onPressed: (){
                    final data={
                      'email':_emailController.text.trim().toString() ,
                      'password':_passwordController.text.trim().toString()
                    };
                    ref.read(forgetKeyVMProvider.notifier).forgetKey(data, context);


                  }, child: Text('Reset Password'))
                ),
              ],
            ),
          ),
        ),

    );
  }
}
