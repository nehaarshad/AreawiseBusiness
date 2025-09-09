import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/utils/routes/routes_names.dart';
import '../widgets/categoryGrid.dart';
import '../widgets/searchBar.dart';

class Tosearchproduct extends ConsumerStatefulWidget {
  final int userid;
  const Tosearchproduct({super.key,required this.userid});

  @override
  ConsumerState<Tosearchproduct> createState() => _TosearchproductState();
}

class _TosearchproductState extends ConsumerState<Tosearchproduct> {


  List<String> conditions=["New","Used"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body:  Column(
          children: [
            SizedBox(height: 10.h),
            searchBar(id: widget.userid,isAdmin: false,),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("Condition",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18.sp),),
                ),
              ],
            ),
           GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20.w,
            mainAxisSpacing: 5.h,
            childAspectRatio: 3.0,
          ),
          itemCount: conditions.length,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.all(16.w),
          itemBuilder: (context, index) {
            final category = conditions[index];
            if (category == null ) return const SizedBox.shrink();

            return InkWell(
              onTap: ()  {
              final   parameters={
            "id": widget.userid,
            "category": "All",
            "condition":category
            };
              print(parameters);
                Navigator.pushNamed(context, routesName.explore,arguments: parameters);

          },
              borderRadius: BorderRadius.circular(16.r),
              child: Container(
                height: 20.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                    ),
                  ],
                ),
                child: Center(
                      child: Text(
                        category ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

              ),
            );
          },
        ),
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
                  "category": category.name,
                   "condition":null
                };
                Navigator.pushNamed(context, routesName.explore,arguments: parameters);
                     
              },),
            )
          ],
        ),

    );
  }
}
