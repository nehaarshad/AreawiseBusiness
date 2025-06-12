import 'package:ecommercefrontend/Views/shared/widgets/logout_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../View_Model/UserProfile/UserProfileViewModel.dart';
import '../../../core/utils/routes/routes_names.dart';
import '../../../models/UserAddressModel.dart';
import '../../../models/UserDetailModel.dart';
import '../../../core/utils/colors.dart';
import '../widgets/infoRow.dart';
import '../widgets/profileImageWidget.dart';

class profileDetailView extends ConsumerStatefulWidget {
  int id;
  String role;
  profileDetailView({required this.id,required this.role});

  @override
  ConsumerState<profileDetailView> createState() => _profileDetailViewState();
}

class _profileDetailViewState extends ConsumerState<profileDetailView> {

  late String setRole;
  String  userRole(UserDetailModel user){
    if(user.role=='Admin'){
      setRole=user.role!;

    }
    else{
      setRole=widget.role;
    }
    return setRole;
  }

  @override
  Widget build(BuildContext context) {
    final userdetail = ref.watch(
      UserProfileViewModelProvider(widget.id.toString()),
    ); //get user detail from model
    return Scaffold(
      appBar: AppBar(
backgroundColor: Appcolors.whiteColor,
        actions: [
          Row(
            children: [
              Text("Edit",style: TextStyle(fontSize: 18.sp,color: Appcolors.blueColor),),
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      routesName.editprofile,
                      arguments: widget.id,
                    );
                  },
                  icon: Icon(Icons.edit,color: Appcolors.blueColor,size: 20.h,)),
            ],
          )
        ],
      ),
      backgroundColor: Appcolors.whiteColor,
      body: userdetail.when(
        loading: () => Center(
              child: CircularProgressIndicator(color: Appcolors.blackColor),),
        data: (user) {
          setRole=userRole(user!);
          if (user == null) return const Center(child: Text("User not found"));
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Center(
                child: Column(
                  children: [
                    ProfileImageWidget(user: user, height: 150.h, width: 200.w),
                    SizedBox(height: 20.h),
                    userInfo(user: user,role: setRole,),
                    SizedBox(height: 10.h),
                    Divider(),
                    SizedBox(height: 10.h),
                    addressInfo(address: user.address),

                  ],
                ),
              ),
            ),
          );
        },
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class userInfo extends StatelessWidget {
  final UserDetailModel user;
   final String role;
   userInfo({required this.user,required this.role});

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        infoWidget(heading: "Username", value: user.username!),
        infoWidget(heading: "Username", value: user.email!),
        infoWidget(heading: "Role", value: role),
        infoWidget(
          heading: "Contact",
          value: user.contactnumber?.toString() ?? 'No number',
        ),
      ],
    );
  }
}

//where user address details shows
class addressInfo extends StatelessWidget {
  final Address? address;

  const addressInfo({this.address});

  @override
  Widget build(BuildContext context) {
    if (address == null) {
      return const Text('No address information');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(
          'Address Information',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
         SizedBox(height: 8.h),
        infoWidget(heading: "Sector", value: address?.sector ?? 'N/A'),
        infoWidget(heading: "City", value: address?.city ?? 'N/A'),
        infoWidget(heading: "Address", value: address?.address ?? 'N/A'),
      ],
    );
  }
}
