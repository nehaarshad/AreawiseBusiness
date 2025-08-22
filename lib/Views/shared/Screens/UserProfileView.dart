import 'package:ecommercefrontend/Views/shared/widgets/logout_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../View_Model/UserProfile/UserProfileViewModel.dart';
import '../../../View_Model/adminViewModels/UserViewModel.dart';
import '../../../core/utils/routes/routes_names.dart';
import '../../../models/UserAddressModel.dart';
import '../../../models/UserDetailModel.dart';
import '../../../core/utils/colors.dart';
import '../widgets/infoRow.dart';
import '../widgets/profileImageWidget.dart';

class profileDetailView extends ConsumerStatefulWidget {
  int id;
  profileDetailView({required this.id});

  @override
  ConsumerState<profileDetailView> createState() => _profileDetailViewState();
}

class _profileDetailViewState extends ConsumerState<profileDetailView> {

  @override
  Widget build(BuildContext context) {
    final userdetail = ref.watch(
      UserProfileViewModelProvider(widget.id.toString()),
    ); //get user detail from model
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
backgroundColor: Appcolors.whiteSmoke,
        actions: [
          Row(
            children: [
              Text("Edit",style: TextStyle(fontSize: 18.sp,color: Appcolors.baseColor),),
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      routesName.editprofile,
                      arguments: widget.id,
                    );
                  },
                  icon: Icon(Icons.edit,color: Appcolors.baseColor,size: 20.h,)),
            ],
          )
        ],
      ),
      backgroundColor: Appcolors.whiteSmoke,
      body: userdetail.when(
        loading: () => Center(
              child: CircularProgressIndicator(color: Appcolors.blackColor),),
        data: (user) {
          if (user == null) return const Center(child: Text("User not found"));
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 28.0.w,right: 28.w,top: 28.h,bottom: 20.h),

                  child: Center(
                    child: Column(
                      children: [
                        ProfileImageWidget(user: user, height: 150.h, width: 200.w),
                        SizedBox(height: 20.h),
                        userInfo(user: user,),
                        SizedBox(height: 10.h),
                        Divider(),
                        SizedBox(height: 10.h),
                        addressInfo(address: user.address),
                        SizedBox(height: 60.h),


                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12.0.w,right: 12.w,top: 0.h,bottom: 0.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        softWrap: true,
                        'Do you want to delete account forever?',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      InkWell(
                        onTap: ()async{
                          await ref.read(UserViewModelProvider.notifier).deleteusers(user.id.toString(),context);

                        },
                        child: Container(
                          height: 35.h,
                          //    margin: EdgeInsets.symmetric(horizontal: 90.w),
                          width: 75.w,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Center(
                            child: Text("Delete", style: TextStyle(color: Appcolors.whiteSmoke,fontWeight: FontWeight.bold,fontSize: 15.sp)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
   userInfo({required this.user,});

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        infoWidget(heading: "Username", value: user.username!),
        infoWidget(heading: "Username", value: user.email!),
        infoWidget(heading: "Role", value: user.role!),
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
