import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommercefrontend/core/utils/textStyles.dart';
import 'package:ecommercefrontend/models/serviceProviderModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/colors.dart';

class ServiceDetailView extends ConsumerStatefulWidget {
  final ServiceProviders provider;
  const ServiceDetailView({super.key,required this.provider});

  @override
  ConsumerState<ServiceDetailView> createState() => _ServiceDetailViewState();
}

class _ServiceDetailViewState extends ConsumerState<ServiceDetailView> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(actions: [

      ],),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            spacing: 25.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 250.h,
                child: PageView(
                  children: [
                    CachedNetworkImage(
                      imageUrl:    widget.provider.ImageUrl ??
                          "https://th.bing.com/th/id/OIP.GnqZiwU7k5f_kRYkw8FNNwHaF3?rs=1&pid=ImgDetMain",
                      fit: BoxFit.contain,
                      errorWidget:
                          (context, error, stackTrace) =>  Icon(
                        Icons.image_not_supported_outlined,
                        size: 50.h,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("", style: TextStyle( color: Colors.black,)),
                  Column(
                    children: [
                      Icon(Icons.phone,color: Appcolors.baseColor,size: 20.h,),
                      Text(
                        "${widget.provider.contactnumber}",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14.sp,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  Text("|", style: TextStyle( color: Colors.black,)),
                  Column(
                    children: [
                      Icon(Icons.email,color: Appcolors.baseColor,size: 20.h,),
                      Text(
                        "0${widget.provider.email}",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14.sp,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 12.0.w),
                child:   Column(
                  spacing: 5.h,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Service Provider: ",
                            style: TextStyle(
                              color: Appcolors.baseColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                              text: "${widget.provider.providerName}",
                              style: AppTextStyles.body
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Location: ",
                            style: TextStyle(
                              color: Appcolors.baseColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                              text: "${widget.provider.location}",
                              style: AppTextStyles.body
                          ),
                        ],
                      ),
                    ),

                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Experience: ",
                            style: TextStyle(
                              color: Appcolors.baseColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: "${widget.provider.experience} year",
                            style: AppTextStyles.body
                          ),
                        ],
                      ),
                    ),

                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Availability: ",
                            style: TextStyle(
                              color: Appcolors.baseColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: widget.provider.OpenHours,
                            style: AppTextStyles.body
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0.w),
                child: Table(
                    border: TableBorder.all(color:Appcolors.baseColor),
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(1), // cost column narrower
                },
                  children: [ // Header row
                    TableRow(
                      decoration: BoxDecoration(
                          color: Appcolors.baseColorLight30),
                      children: const [
                        Padding( padding: EdgeInsets.all(8.0),
                          child: Text("Service Detail",
                              style: TextStyle(fontWeight: FontWeight.bold,color: Appcolors.whiteSmoke)), ),
                        Padding( padding: EdgeInsets.all(8.0),
                          child: Text("Cost",
                              style: TextStyle(fontWeight: FontWeight.bold,color: Appcolors.whiteSmoke)), ),
                      ],
                    ),
                     for (var detail in widget.provider.serviceDetails!)
                       TableRow(
                         children: [
                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: RichText(text: TextSpan(
                               text: detail.serviceDetails ?? "N/A",
                               style: AppTextStyles.body
                             )), ),
                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child:  RichText(text: TextSpan(
                                 text: "${detail.cost ?? "N/A"}",
                                 style: AppTextStyles.body
                             )),
                           ),
                         ],
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
