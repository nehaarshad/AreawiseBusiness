import 'package:ecommercefrontend/core/services/app_APIs.dart';
import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:ecommercefrontend/core/utils/routes/routes.dart';
import 'package:ecommercefrontend/core/utils/routes/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
     builder: (_,child){
        return ProviderScope(
          child: MaterialApp(
                 debugShowCheckedModeBanner: false,
                 title: 'E-Commerce Seventeen',
                 theme: ThemeData(
                   visualDensity: VisualDensity.adaptivePlatformDensity,

                 colorScheme: ColorScheme.fromSeed(
                 seedColor: Appcolors.baseColor,
                 primary: Appcolors.baseColor,
                 ),
                 // Set the primary color as well for legacy components
                 //   primaryColor: Appcolors.blueColor,
                 ),
                 initialRoute: routesName.splash,
                 onGenerateRoute: Routes.createroutes,
                 ),
        );

     },
    );
  }
}
