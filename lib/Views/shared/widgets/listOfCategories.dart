import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../View_Model/adminViewModels/categoriesViewModel.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/routes/routes_names.dart';
import '../../../models/categoryModel.dart';

class CategoriesList extends ConsumerStatefulWidget {
  final int userid;
  final Function(Category) onCategorySelected;
  const CategoriesList({super.key,required this.userid, required this.onCategorySelected,});

  @override
  ConsumerState<CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends ConsumerState<CategoriesList> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(categoryViewModelProvider.notifier).getCategories();
    });
  }


  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoryViewModelProvider);

    return Consumer(
        builder: (context, ref, child) {
          final categoriesAsync = ref.watch(categoryViewModelProvider);
          return categoriesAsync.isLoading ? const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: LinearProgressIndicator(color: Appcolors.baseColor),
            ),
          ) : (categoriesAsync.category != null)
              ? Categories(categoriesAsync.category)
              : SizedBox.shrink();
        }
    );
  }

  Widget Categories(List<Category?>? categories) {

    if(categories == null){
      return SizedBox.shrink();
    }
    else{
      if (categories.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text("No Categories Yet!"),
          ),
        );
      }

      return ListView.builder(
        itemCount: categories.length,
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final category = categories[index];
          if (category == null || category.name =="All") return SizedBox.shrink();
          print(category.image?.imageUrl);
          return InkWell(
            onTap: () => widget.onCategorySelected(category),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  (category.image != null && category.image!.imageUrl!.isNotEmpty)
                      ? Image.network(
                    category.image!.imageUrl!,
                    fit: BoxFit.cover,
                    width: 50.w,
                    height: 50.h,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error);
                    },
                  )
                      : const Icon(Icons.image_not_supported),
                  Text("${category.name}",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15.sp),),

                ],
              ),
            ),
          );

        },
      );
    }
  }

}