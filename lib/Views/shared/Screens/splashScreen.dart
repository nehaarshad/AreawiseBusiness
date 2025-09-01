import 'package:ecommercefrontend/core/services/splashServices.dart';
import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class splashView extends ConsumerStatefulWidget {
  const splashView({super.key});

  @override
  ConsumerState<splashView> createState() => _splashViewState();
}

class _splashViewState extends ConsumerState<splashView> {
  @override
  void initState() {
    super.initState();
    ref.read(splashserviceProvider).checkAuth(context, ref);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.baseWhite,
      body: Center(
        child: Image.asset('assets/images/appLogo.jpg',width: 900.w,height: 5000.h,),
      ),
    );
  }
}
