import 'package:ecommercefrontend/Views/shared/widgets/colors.dart';
import 'package:ecommercefrontend/core/utils/routes/routes_names.dart';
import 'package:ecommercefrontend/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final double height = MediaQuery.of(context).size.height * 1;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text('Login')),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                }, child: Text("forget password?"))
              ],),
              SizedBox(height: height * .07),
              Consumer(
                builder: (context, ref, child) {
                  final loading = ref.watch(loginProvider);
                  return CustomButton(
                    text: "Login",
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
              SizedBox(height: height * .02),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 2,
                  horizontal: 15,
                ),
                child: Row(
                  children: [
                    Text("Don't have an Account?"),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, routesName.signUp);
                      },
                      child: Text(
                        "SignUp",
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
    );
  }
}
