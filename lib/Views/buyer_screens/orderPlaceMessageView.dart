import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:ecommercefrontend/models/UserDetailModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/utils/routes/routes_names.dart';
import '../shared/widgets/buttons.dart';

class Orderplacemessageview extends StatelessWidget {

  final UserDetailModel user;
   Orderplacemessageview({super.key,required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.whiteColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Order Placed Successfully!",style: TextStyle(
                color: Appcolors.blackColor,fontSize: 25.sp,fontWeight: FontWeight.bold
              ),),
              Image.asset('assets/images/successImage.jpg',),
              SizedBox(height: 80.h,),
              CustomButton(text:"Continue..." ,onPressed: (){
                if(user.role=="Admin"){
                  Navigator.pushNamed(context, routesName.aHome, arguments: user);
                }
                else
                {Navigator.pushNamed(context, routesName.dashboard,arguments: user);}
              },),
          
            ],
          ),
        ),
      ),
    );
  }
}
