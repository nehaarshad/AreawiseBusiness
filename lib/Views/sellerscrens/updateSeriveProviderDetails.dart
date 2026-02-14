import 'package:ecommercefrontend/View_Model/SellerViewModels/addServiceProviderViewModel.dart';
import 'package:ecommercefrontend/Views/sellerscrens/widgets/serviceProviderLocationDropDown.dart';
import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:ecommercefrontend/models/serviceProviderModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../View_Model/SellerViewModels/updateServiceProviderDetailsViewModel.dart';
import '../shared/widgets/buttons.dart';

class updateProviderOfServiceView extends ConsumerStatefulWidget {
  final ServiceProviders service;
  const updateProviderOfServiceView({super.key,required this.service});

  @override
  ConsumerState<updateProviderOfServiceView> createState() => _updateProviderOfServiceViewState();
}

class _updateProviderOfServiceViewState extends ConsumerState<updateProviderOfServiceView> {
  @override
  Widget build(BuildContext context) {
    final state=ref.watch(updateServiceProviderViewModelProvider(widget.service));
    final model= ref.read(updateServiceProviderViewModelProvider(widget.service).notifier);
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Appcolors.baseWhite,
        ),
        backgroundColor: Appcolors.baseWhite,
        body:Center(
            child:   Form(
              key:model.key,

              child: SingleChildScrollView(
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 12.0.w),
                  child: Column(
                    spacing: 10.h,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await model.pickImages(context);
                        },
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 50.r,
                              backgroundImage: model.uploadimage != null
                                  ? FileImage(model.uploadimage!)
                                  : NetworkImage(
                                  "https://th.bing.com/th/id/R.8e2c571ff125b3531705198a15d3103c?rik=gzhbzBpXBa%2bxMA&riu=http%3a%2f%2fpluspng.com%2fimg-png%2fuser-png-icon-big-image-png-2240.png&ehk=VeWsrun%2fvDy5QDv2Z6Xm8XnIMXyeaz2fhR3AgxlvxAc%3d&risl=&pid=ImgRaw&r=0"
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

                      SizedBox(height: 20.h,),
                      // accountNumber field
                      TextFormField(
                        controller: model.providerName,
                        decoration: InputDecoration(
                          labelText: "Service Provider Name",
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0.r),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) { return "Provider name is required"; } return null;
                        },
                      ),

                      TextFormField(
                        controller: model.email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0.r),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) { return "Provider email is required"; } return null;
                        },
                      ),
                      TextFormField(
                        controller: model.contactnumber,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Contact Number ",
                          prefixIcon: Icon(Icons.numbers_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0.r),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) { return "contact number is required"; } return null;
                        },
                      ),


                      TextFormField(
                        controller: model.experience,
                        decoration: InputDecoration(
                          labelText: "Experience",
                          prefixIcon: Icon(Icons.work_history),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0.r),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) { return "experience is required"; } return null;
                        },
                      ),

                      TextFormField(
                        controller: model.OpenHours,
                        decoration: InputDecoration(
                          labelText: "Working slots",
                          hintText: "Mon-Fri (9:00am - 5:00pm)",
                          prefixIcon: Icon(Icons.access_time),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0.r),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) { return "Availability time is required"; } return null;
                        },
                      ),

                      updateShopAreaDropDown(service: widget.service,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Your Services Details",style: TextStyle(fontSize: 20.sp)),
                          TextButton(onPressed: (){
                            model.addServiceRow();
                          }, child: Text("  +  Add More",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              decorationColor: Appcolors.baseColor,
                              decorationStyle: TextDecorationStyle.solid,),)),

                        ],
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: model.serviceRows.length,
                        itemBuilder: (context, index) {
                          final row = model.serviceRows[index];
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: TextFormField(
                                      controller: row["detail"],
                                      maxLines: 2,
                                      decoration: InputDecoration(
                                        labelText: "Service Detail",

                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8.0.r),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 3.w,),
                                  Expanded(
                                    child: TextFormField(
                                      controller: row["cost"],
                                      maxLines: 2,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: "Cost",

                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8.0.r),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if(index!=0)
                                    IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => model.removeServiceRow(index),
                                    ),
                                  if(index==0)
                                    SizedBox(width: 50.w,),
                                ],
                              ),
                              SizedBox(height: 10.h,),
                            ],
                          );
                        },
                      ),

                      CustomButton(text: "Update Service", onPressed: ()async{
                        await ref.read(updateServiceProviderViewModelProvider(widget.service).notifier).updateServiceProvider(userid: widget.service.providerID.toString(),serviceid: widget.service.id.toString(),context: context);
                      }),
                      InkWell(
                        onTap:()async{
                          model.Cancel(context);
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
                      ),
                      SizedBox(height: 20.h,),
                    ],
                  ),
                ),
              ),
            )
        )
    );
  }
}
