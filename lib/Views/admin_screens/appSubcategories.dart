import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:ecommercefrontend/core/utils/textStyles.dart';
import 'package:ecommercefrontend/models/SubCategoryModel.dart';
import 'package:ecommercefrontend/models/categoryModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../View_Model/adminViewModels/categoriesViewModel.dart';
import '../../View_Model/adminViewModels/subCategoriesViewModel.dart';

class SubcategoriesView extends ConsumerStatefulWidget {
  Category category;
  SubcategoriesView({super.key,required this.category});

  @override
  ConsumerState<SubcategoriesView> createState() => _SubcategoriesViewState();
}

class _SubcategoriesViewState extends ConsumerState<SubcategoriesView> {
  final TextEditingController subCategoryController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    final subcategories = ref.watch(subCategoryViewModelProvider(widget.category.name!));

    return Scaffold(
      backgroundColor: Appcolors.whiteSmoke,
      appBar: AppBar(
        title:  Text(
          ' Subcategories of ${widget.category.name}',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14.h
          )
        ),
        actions: [
          IconButton(onPressed:()=>  AddSubcategoryDialog(), icon:Padding(
            padding:  EdgeInsets.only(right: 8.0.w),
            child: Icon(Icons.add,color: Appcolors.baseColorLight30, size: 20.h),
          ) )
        ],
        backgroundColor: Appcolors.whiteSmoke,
      ),

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
                ElevatedButton(
                  onPressed: () {
                    ref.read(categoryViewModelProvider.notifier).getCategories();
                  },
                  child: Text('Retry'),
                ),
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
      itemBuilder: (context, index) {
        final subcategory = sub[index];
        return ListTile(
          leading:  Text("${index+1}-",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18.sp),),

          title: Text("${subcategory!.name}",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16.sp),),
                  trailing:IconButton(
                        onPressed: (){
                          DeleteDialogBox(subcategory);
                        },
                        icon: Icon(Icons.delete, size: 20.h,color: Colors.red,),),


                );
      },
    ); }

  void AddSubcategoryDialog() {
    subCategoryController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title:  Text(
          'Add New Subcategory',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.h,
          ),
        ),
        content: TextField(
          controller: subCategoryController,
          decoration: InputDecoration(
            hintText: 'Enter Subcategory name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Appcolors.baseColorLight30, width: 2.w),
            ),
          ),
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (subCategoryController.text.trim().isNotEmpty) {
                await   ref.read(subCategoryViewModelProvider(widget.category.name!).notifier)
                    .addSubcategory(subCategoryController.text.trim(),widget.category.id!);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Appcolors.baseColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void DeleteDialogBox(Subcategory subcategory) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title:  Text(
          'Delete Subcategory',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${subcategory.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          TextButton(
            onPressed: () async {
              await ref.read(subCategoryViewModelProvider(widget.category.name!).notifier)
                  .deleteSubcategory(subcategory.id.toString());
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

}
