import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/colors.dart';
import '../../../core/utils/routes/routes_names.dart';

class searchBar extends ConsumerStatefulWidget {
  final int id;
  final bool isAdmin;
  const searchBar({super.key, required this.id,required this.isAdmin});

  @override
  ConsumerState<searchBar> createState() => _SearchBarState();
}

class _SearchBarState extends ConsumerState<searchBar> {
  final TextEditingController searchController = TextEditingController();

  void _navigateToSearch(String search) {
    if (search.trim().isNotEmpty) {
      if(widget.isAdmin){
        final parameters = {
          'id': widget.id,
          'search': search.trim(),
        };
        Navigator.pushNamed(context, routesName.manageProduct, arguments: parameters);

      }
      else{
        final parameters = {
          'id': widget.id,
          'search': search.trim(),
        };
        Navigator.pushNamed(context, routesName.search, arguments: parameters);


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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0.w),
      child: SearchBar(
        controller: searchController,
        hintText: "Search Products",
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