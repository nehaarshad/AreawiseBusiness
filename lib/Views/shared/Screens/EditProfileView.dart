import 'package:ecommercefrontend/core/utils/routes/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../View_Model/UserProfile/EditProfileViewModel.dart';
import '../../../models/UserDetailModel.dart';
import '../../../core/utils/colors.dart';

class editProfile extends ConsumerStatefulWidget {
  final int id;

  editProfile({required this.id});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<editProfile> {
  @override
  void dispose() {
    super.dispose();
  }

  Widget buildRoleDropdown(EditProfileViewModel model, String currentUserRole) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: model.role, // Ensure this matches one of the available items
          decoration: InputDecoration(
            labelText: "Role",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0.r),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please select a role";
            }
            return null;
          },
          onChanged: (value) {
            setState(() {
              model.role = value!;
            });
          },
          items: [
            if (currentUserRole == "Admin") // Only show "Admin" if current user is admin
              DropdownMenuItem(value: "Admin", child: Text("Admin")),
            DropdownMenuItem(value: "Buyer", child: Text("Buyer")),
            DropdownMenuItem(value: "Seller", child: Text("Seller")),
            DropdownMenuItem(value: "Both", child: Text("Both")),
          ].where((item) => item != null).toList(),
        ),
      ],
    );
  }
  Widget UserImage(UserDetailModel user, EditProfileViewModel model) {
    return Column(
      children: [
        GestureDetector(
          onTap:(){ model.pickImages(context);},
          child: Stack(
            children: [
              CircleAvatar(
                radius: 50.r,
                backgroundImage:
                    model.uploadimage != null
                        ? FileImage(model.uploadimage!)
                        : user.image?.imageUrl != null &&
                            user.image!.imageUrl!.isNotEmpty
                        ? NetworkImage(user.image!.imageUrl!)
                        : NetworkImage(
                          "https://th.bing.com/th/id/OIP.GnqZiwU7k5f_kRYkw8FNNwHaF3?rs=1&pid=ImgDetMain",
                        ),
              ),
              Positioned(
                bottom: 5,
                right: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.blueGrey,
                    size: 25,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget formFields(EditProfileViewModel model) {
    return Column(
      spacing: 10.h,
      children: [
        TextFormField(
          controller: model.username,
          decoration:  InputDecoration(labelText: "Username", border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0.r),
          ),),
        ),

        TextFormField(
          controller: model.email,
          decoration:  InputDecoration(labelText: "Email", border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0.r),
          ),),
        ),

        TextFormField(
          controller: model.contactnumber,
          decoration:  InputDecoration(labelText: "Contact Number", border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0.r),
          ),),
          keyboardType: TextInputType.phone,
        ),

        buildRoleDropdown(model,model.currentRole),

        TextFormField(
          controller: model.sector,
          decoration:  InputDecoration(labelText: "Sector", border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0.r),
          ),),
        ),

        TextFormField(
          controller: model.city,
          decoration:  InputDecoration(labelText: "City", border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0.r),
          ),),
        ),

        TextFormField(
          controller: model.address,
          decoration:  InputDecoration(labelText: "Address",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0.r),
            ),
          ),
        ),
      ],
    );
  }

  Widget UpdateButton(
    AsyncValue<UserDetailModel?> state,
    EditProfileViewModel viewModel,
    BuildContext context,
  ) {
    return InkWell(
      onTap: state.isLoading ? null : () => updateData(viewModel, context),
      child: Container(
        height: 40.h,
        margin: EdgeInsets.symmetric(horizontal: 25.w),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Appcolors.baseColor,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Center(
          child:
          state.isLoading
              ? CircularProgressIndicator(color: Appcolors.whiteSmoke)
              : Text("Update", style: TextStyle(color: Appcolors.whiteSmoke,fontWeight: FontWeight.bold,fontSize: 15.sp)),
        ),
      ),
    );
  }

  void updateData(EditProfileViewModel viewModel, BuildContext context) {
    if (viewModel.key.currentState!.validate()) {
      final data = {
        'username': viewModel.username.text,
        'email': viewModel.email.text,
        'contactnumber': int.parse(viewModel.contactnumber.text),
        'role': viewModel.role,
        'sector': viewModel.sector.text,
        'city': viewModel.city.text,
        'address': viewModel.address.text,
      };
      print("useranme:  ${data['username']} with type:  ${data['username'].runtimeType}");
      print("email:  ${data['email']} with type:  ${data['email'].runtimeType}");
      print("contactnumber:  ${data['contactnumber']} with type:  ${data['contactnumber'].runtimeType}");
      print("password:  ${data['password']} with type:  ${data['password'].runtimeType}");
      print("role:  ${data['role']} with type:  ${data['role'].runtimeType}");
      print("sector:  ${data['sector']} with type:  ${data['sector'].runtimeType}");
      print("city:  ${data['city']} with type:  ${data['city'].runtimeType}");
      print("address:  ${data['address']} with type:  ${data['address'].runtimeType}");
      viewModel.updateUser(data, viewModel.uploadimage, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(
      editProfileViewModelProvider(widget.id.toString()),
    );
    final editProfile = ref.read(
      editProfileViewModelProvider(widget.id.toString()).notifier,
    );

    return Scaffold(
      appBar: AppBar(

          actions: [
            TextButton(onPressed: (){
              Navigator.pushNamed(context, routesName.changePassword,arguments: widget.id.toString());

            }, child: Text("Change Password",style: TextStyle(color: Appcolors.baseColor),))
          ],
      ),
      body: userState.when(
        loading:
            () => Center(
              child: CircularProgressIndicator(color: Appcolors.blackColor),
            ),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (user) {
          if (user != null) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: editProfile.key,
                child: Column(
                  children: [
                    UserImage(user, editProfile),
                     SizedBox(height: 20.h),
                    formFields(editProfile),
                     SizedBox(height: 20.h),

                    UpdateButton(userState, editProfile, context),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: Text('User not found'));
          }
        },
      ),
    );
  }
}
