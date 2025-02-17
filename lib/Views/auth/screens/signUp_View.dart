import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../View_Model/auth/SignUp_viewModel.dart';
import '../../../core/utils/routes/routes_names.dart';
import '../../../core/utils/utils.dart';
import '../../shared/widgets/buttons.dart';
import '../../shared/widgets/colors.dart';

class signUp_View extends ConsumerStatefulWidget {
  const signUp_View({super.key});

  @override
  ConsumerState<signUp_View> createState() => _signUp_ViewState();
}

class _signUp_ViewState extends ConsumerState<signUp_View> {

  ValueNotifier<bool> pswrd=ValueNotifier<bool>(true);
  ValueNotifier<bool> cpswrd=ValueNotifier<bool>(true);

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _shopAddressController = TextEditingController();
  final TextEditingController _shopCategoryController = TextEditingController();

  FocusNode username = FocusNode();
  FocusNode email = FocusNode();
  FocusNode password = FocusNode();
  FocusNode confirmPassword = FocusNode();
  FocusNode contactNumber = FocusNode();
  FocusNode shopAddress = FocusNode();
  FocusNode shopCategory = FocusNode();

  bool _isBuyer = true;

  // Dispose method
  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailController.dispose();
    _contactNumberController.dispose();
    _shopAddressController.dispose();
    _shopCategoryController.dispose();

    username.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    contactNumber.dispose();
    shopAddress.dispose();
    shopCategory.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final signUpviewmodel = ref.read(signupProvider.notifier);
    final double height = MediaQuery.of(context).size.height * 1;

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(child: Text('Sign Up'))
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Column(
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
                  onFieldSubmitted: (value) {
                    Utils.focusarea(context, username, email);
                  },
                ),
          
                // Email field
                TextFormField(
                  controller: _emailController,
                  focusNode: email,
                  decoration: InputDecoration(
                    hintText: "Email",
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  onFieldSubmitted: (value) {
                    Utils.focusarea(context, email, contactNumber);
                  },
                ),
          
                // Contact Number field
                TextFormField(
                  controller: _contactNumberController,
                  focusNode: contactNumber,
                  decoration: InputDecoration(
                    hintText: "Contact Number",
                    prefixIcon: Icon(Icons.phone),
                  ),
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

                    );
                  },
                ),

                // Role selection (Combo Box)
                DropdownButton<String>(
                  value: _isBuyer ? "buyer" : "admin",
                  onChanged: (value) {
                    setState(() {
                      _isBuyer = value == "buyer";
                    });
                  },
                  items: [
                    DropdownMenuItem(value: "buyer", child: Text("Buyer")),
                  //  DropdownMenuItem(value: "seller", child: Text("Seller")),
                    DropdownMenuItem(value: "admin", child: Text("Admin")),
                  ],
                ),
                SizedBox(height: height * .1),
                // SignUp button
                Consumer(builder: (context,ref,child){
                  final loading =ref.watch(signupProvider);
                 return CustomButton(
                    text: "Sign Up",
                    onPressed: () {
                      if (_usernameController.text.isEmpty) {
                        Utils.flushBarErrorMessage("Please Enter Username", context);
                      } else if (_emailController.text.isEmpty) {
                        Utils.flushBarErrorMessage("Please Enter Email", context);
                      } else if (_contactNumberController.text.isEmpty) {
                        Utils.flushBarErrorMessage("Please Enter Contact Number", context);
                      } else if (_passwordController.text.isEmpty) {
                        Utils.flushBarErrorMessage("Please Enter Password", context);
                      } else if (_passwordController.text.length < 8) {
                        Utils.flushBarErrorMessage("Please Enter 8 digit Password", context);
                      } else if (_passwordController.text != _confirmPasswordController.text) {
                        Utils.flushBarErrorMessage("Passwords do not match", context);
                      } else {
                        Map data = {
                          'username': _usernameController.text.toString(),
                          'email': _emailController.text.toString(),
                          'contactnumber': _contactNumberController.text.toString(),
                          'password': _passwordController.text.toString(),
                          'role': _isBuyer ? 'buyer' : 'admin',
                        };
                        signUpviewmodel.SignUpApi(data, context);
                      }
                    },
                    isLoading: loading,
                  );
                }
                ),
                SizedBox(height: height*.02,),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 15),
                  child: Row(

                    children: [
                      Text("Already have an Account?"),
                      InkWell(
                          onTap: (){
                            Navigator.pushNamed(context, routesName.login);
                          },
                          child: Text("Login",style: TextStyle(color: Appcolors.blueColor,fontWeight: FontWeight.bold),)
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
