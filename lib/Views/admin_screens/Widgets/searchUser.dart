import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/colors.dart';
import '../../../core/utils/routes/routes_names.dart';


class searchUser extends ConsumerStatefulWidget {
  searchUser({super.key});

  @override
  ConsumerState<searchUser> createState() => _searchShopState();
}

class _searchShopState extends ConsumerState<searchUser> {
  final TextEditingController searchController = TextEditingController();

  void _navigateToSearch(String search) {
    if (search.trim().isNotEmpty) {
      Navigator.pushNamed(context, routesName.searchUser, arguments: search.trim());
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0.w),
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
    );
  }
}

