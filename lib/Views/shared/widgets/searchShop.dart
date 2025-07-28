import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/colors.dart';
import '../../../core/utils/routes/routes_names.dart';


class searchShop extends ConsumerStatefulWidget {
  int id;
  bool myShop;
   searchShop({super.key,required this.id,required this.myShop});

  @override
  ConsumerState<searchShop> createState() => _searchShopState();
}

class _searchShopState extends ConsumerState<searchShop> {
  final TextEditingController searchController = TextEditingController();

  void _navigateToSearch(String search) {
    if (search.trim().isNotEmpty) {
    if(widget.myShop){
      final parameters = {
        'id': widget.id,
        'search': search.trim(),
      };
      Navigator.pushNamed(context, routesName.searchShop, arguments: parameters);

    }
    else{
      final parameters = {
        'id': widget.id,
        'search': search.trim(),
      };
      Navigator.pushNamed(context, routesName.findShop, arguments: parameters);


    }
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350.w,
      child: Padding(
        padding:  EdgeInsets.only(right: 8.0.w,bottom: 5.h),
        child: SearchBar(
            controller: searchController,
            hintText: "Search ",
            leading: const Icon(
              Icons.search,
              color: Appcolors.blueColor,
            ),

            onSubmitted: (value) {
              _navigateToSearch(value);
            },
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(70.0.r),
              ),
            ),
            elevation: WidgetStateProperty.all(1.0),
            backgroundColor: WidgetStateProperty.all(Colors.white),
            padding: WidgetStateProperty.all(
              EdgeInsets.symmetric(horizontal: 16.0.w),
            ),
          ),
      ),
    );

  }
}

