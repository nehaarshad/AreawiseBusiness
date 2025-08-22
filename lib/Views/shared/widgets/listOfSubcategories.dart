import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:ecommercefrontend/core/utils/routes/routes_names.dart';
import 'package:ecommercefrontend/core/utils/textStyles.dart';
import 'package:ecommercefrontend/models/SubCategoryModel.dart';
import 'package:ecommercefrontend/models/categoryModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../View_Model/adminViewModels/categoriesViewModel.dart';
import '../../../View_Model/adminViewModels/subCategoriesViewModel.dart';

class SubcategoriesList extends ConsumerStatefulWidget {
  final Category category;
  final int userid;
  const SubcategoriesList({super.key,required this.category,required this.userid});

  @override
  ConsumerState<SubcategoriesList> createState() => _SubcategoriesListState();
}

class _SubcategoriesListState extends ConsumerState<SubcategoriesList> {
  @override
  Widget build(BuildContext context) {
    final subcategories = ref.watch(subCategoryViewModelProvider(widget.category.name!));

    return Scaffold(


      body: subcategories.when(
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: CircularProgressIndicator(color: Appcolors.baseColor),
          ),
        ),
        data: (categories) => Subcategories(categories),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 45.h),
                SizedBox(height: 16),
                Text('Error loading SubCategories'),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),

    );
  }


  Widget Subcategories(List<Subcategory?> sub) {
    if (sub.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text("No subCategories Yet "),
        ),
      );
    }

    return ListView.builder(
      itemCount: sub.length,
      physics: AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final subcategory = sub[index];
        return Column(
          children: [
            ListTile(
              onTap: (){
                final parameter={
                  "id":widget.userid,
                  "name":subcategory.name!
                };
                Navigator.pushNamed(context, routesName.subcategoriesProductView,arguments: parameter);
              },
              title: Text("${subcategory!.name}",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16.sp),),
              trailing: Icon(Icons.navigate_next_rounded,color: Appcolors.baseColor,),
            ),
            Divider()
          ],
        );
      },
    );
  }
}
