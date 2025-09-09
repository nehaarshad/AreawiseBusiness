import 'package:ecommercefrontend/core/utils/textStyles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpod/riverpod.dart';
import '../../../View_Model/UserProfile/EditProfileViewModel.dart';
import '../../../models/UserDetailModel.dart';
import '../../View_Model/adminViewModels/addUserViewModel.dart';
import '../../core/utils/notifyUtils.dart';
import '../shared/widgets/buttons.dart';
import '../../core/utils/colors.dart';

class addUser extends ConsumerStatefulWidget {

  addUser({super.key});

  @override
  _AddUserViewState createState() => _AddUserViewState();
}

class _AddUserViewState extends ConsumerState<addUser> {

  late final addUserViewModel _viewModel;
  ValueNotifier<bool> pswrd = ValueNotifier<bool>(true);
  ValueNotifier<bool> cpswrd = ValueNotifier<bool>(true);
  final formkey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _sectoreController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  FocusNode username = FocusNode();
  FocusNode email = FocusNode();
  FocusNode password = FocusNode();
  FocusNode confirmPassword = FocusNode();
  FocusNode contactNumber = FocusNode();
  FocusNode sector = FocusNode();
  FocusNode city = FocusNode();
  FocusNode address = FocusNode();

  String? _selectedRole;

  @override
  void initState() {
    super.initState();
    Future.microtask(() { // Runs after build completes
      _viewModel = ref.read(addUserViewModelProvider.notifier);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.resetState();
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
            DropdownMenuItem(value: "Admin", child: Text("Admin")),
          ],
        ),
      ],
    );
  }

  Widget UserImage( addUserViewModel model,BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            await model.pickImages(context);
          },
          child: Stack(
            children: [
              CircleAvatar(
                radius: 50.r,
                backgroundImage:
                model.uploadimage != null
                    ? FileImage(model.uploadimage!)
                    :NetworkImage(
                  "https://th.bing.com/th/id/OIP.GnqZiwU7k5f_kRYkw8FNNwHaF3?rs=1&pid=ImgDetMain",
                ),
              ),
              Positioned(
                bottom: 5, // Adjust position of the camera icon
                right: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.blueGrey,
                    size: 25.h,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {

    final state = ref.read(addUserViewModelProvider.notifier);
    void addUser() {
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
            'sector':_sectoreController.text.trim().toString(),
            'city':_cityController.text.trim().toString(),
            'address':_addressController.text.trim().toString()
          };
          if(kDebugMode){

            print("useranme:  ${data['username']} with type:  ${data['username'].runtimeType}");
            print("email:  ${data['email']} with type:  ${data['email'].runtimeType}");
            print("contactnumber:  ${data['contactnumber']} with type:  ${data['contactnumber'].runtimeType}");
            print("password:  ${data['password']} with type:  ${data['password'].runtimeType}");
            print("role:  ${data['role']} with type:  ${data['role'].runtimeType}");
            print("sector:  ${data['sector']} with type:  ${data['sector'].runtimeType}");
            print("city:  ${data['city']} with type:  ${data['city'].runtimeType}");
            print("address:  ${data['address']} with type:  ${data['address'].runtimeType}");
          }

          state.addUser(data,context);
        }
      }
    }


    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
          title: Center(child: Text("Add User",style: AppTextStyles.headline,))),
      body:SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
            child: Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  UserImage(state,context),
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

                  TextFormField(
                    controller: _sectoreController,
                    focusNode: sector,
                    decoration: InputDecoration(
                      hintText: "Sector",
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter Sector";
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) {
                      Utils.focusarea(context, sector, city);
                    },
                  ),
                  TextFormField(
                    controller: _cityController,
                    focusNode: city,
                    decoration: InputDecoration(
                      hintText: "City",
                      prefixIcon: Icon(Icons.location_city_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter City";
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) {
                      Utils.focusarea(context, city, address);
                    },
                  ),
                  TextFormField(
                    controller: _addressController,
                    focusNode: address,
                    decoration: InputDecoration(
                      hintText: "Address",
                      prefixIcon: Icon(Icons.holiday_village_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter address";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10.h),
                  // SignUp button
                  Consumer(
                    builder: (context, ref, child) {
                      final loading = ref.watch(addUserViewModelProvider);
                      return CustomButton(
                        text: "Create User",
                        onPressed: addUser,
                        isLoading: loading.isLoading,
                      );
                    },
                  ),
                  SizedBox(height: 8.h,),
                  Consumer(
                    builder: (context, ref, child) {
                      final loading = ref.watch(addUserViewModelProvider);
                      return  InkWell(
                        onTap:()async{
                       await ref.read(addUserViewModelProvider.notifier).Cancel(context);
                      },
                        child: Container(
                          height: 40.h,
                          margin: EdgeInsets.symmetric(horizontal: 25.w),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Appcolors.whiteSmoke,
                            borderRadius: BorderRadius.circular(15.r),
                            border: Border.all(  // Use Border.all instead of boxShadow for borders
                              color: Appcolors.baseColor,
                              width: 1.0,  // Don't forget to specify border width
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                color: Appcolors.baseColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.sp,
                              ),
                            ),
                          ),
                        ),
                      );


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
