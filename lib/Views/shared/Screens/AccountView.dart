import 'package:ecommercefrontend/Views/shared/widgets/AccountWidget.dart';
import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:ecommercefrontend/core/utils/routes/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/UserDetailModel.dart';

class AccountView extends StatefulWidget {
  final int userid;
  final UserDetailModel? user;
  const AccountView({super.key,required this.userid, this.user});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(

          automaticallyImplyLeading: false,
          leading: IconButton(onPressed: (){
            Navigator.pushNamed(
              context,
              routesName.dashboard,
              arguments: widget.user,
            );
          },
              icon: Icon(Icons.arrow_back,color: Appcolors.baseColorLight30,size: 20.h,)),

          title: const Text('Account',style: TextStyle(fontWeight: FontWeight.w500),),
          backgroundColor: Appcolors.whiteSmoke,
          elevation: 0,
        ),
      backgroundColor: Appcolors.whiteSmoke,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
            itemCount: accountWidgets.length,
            itemBuilder: (context,index){
            final item = accountWidgets[index];
                 return InkWell(
                   onTap: (){
                     Navigator.pushNamed(context, item['route'],arguments: widget.userid);
                   },
                   child: Padding(
                     padding: const EdgeInsets.symmetric(vertical: 12.0,horizontal: 8),
                     child: Row(
                       children: [
                         Icon(item['icon'],color: Appcolors.baseColor,size: 22.h,),
                         SizedBox(width: 18.w,),
                         Text(item['title'],style: TextStyle(color: Colors.black,fontSize: 18.sp),)
                       ],
                     ),
                   ),
                 );

            }
        ),
      )
    );
  }
}
