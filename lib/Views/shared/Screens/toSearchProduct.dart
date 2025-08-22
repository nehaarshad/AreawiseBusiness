import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/routes/routes_names.dart';
import '../../../models/categoryModel.dart';
import '../widgets/categoryGrid.dart';
import '../widgets/searchBar.dart';

class Tosearchproduct extends ConsumerStatefulWidget {
  final int userid;
  const Tosearchproduct({super.key,required this.userid});

  @override
  ConsumerState<Tosearchproduct> createState() => _TosearchproductState();
}

class _TosearchproductState extends ConsumerState<Tosearchproduct> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body:  Column(
          children: [
            SizedBox(height: 10.h),
            searchBar(id: widget.userid,isAdmin: false,),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("Categories",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18.sp),),
                ),
              ],
            ),
            Expanded(
              child: CategoriesGrid(userid: widget.userid,
                onCategorySelected: (category) {
                final parameters={
                  "id": widget.userid,
                  "category": category.name
                };
                Navigator.pushNamed(context, routesName.explore,arguments: parameters);
                     
              },),
            )
          ],
        ),

    );
  }
}
