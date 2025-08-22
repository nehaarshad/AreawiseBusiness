import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../View_Model/adminViewModels/categoriesViewModel.dart';
import '../../../core/utils/colors.dart';
import '../../../models/categoryModel.dart';

class CategoriesGrid extends ConsumerStatefulWidget {
  final int userid;
  final Function(Category) onCategorySelected;
  const CategoriesGrid({super.key,required this.userid, required this.onCategorySelected,});

  @override
  ConsumerState<CategoriesGrid> createState() => _CategoriesGridState();
}

class _CategoriesGridState extends ConsumerState<CategoriesGrid> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(categoryViewModelProvider.notifier).getCategories();
    });
  }


  @override
  Widget build(BuildContext context) {

    return Consumer(
        builder: (context, ref, child) {
          final categoriesAsync = ref.watch(categoryViewModelProvider);
          return categoriesAsync.isLoading ? const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(color: Appcolors.baseColor),
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

      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
          childAspectRatio: 2.0,
        ),
        itemCount: categories.length,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(16.w),
        itemBuilder: (context, index) {
          final category = categories[index];
          if (category == null) return const SizedBox.shrink();

          print(category.image?.imageUrl);

          return InkWell(
            onTap: () => widget.onCategorySelected(category),
            borderRadius: BorderRadius.circular(16.r),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 50.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),
                      child: (category.image != null && category.image!.imageUrl!.isNotEmpty)
                          ? Image.network(
                        category.image!.imageUrl!,
                        fit: BoxFit.cover,
                        width: 80.w,
                        height: 80.h,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.image_not_supported_rounded,
                            size: 40.sp,
                            color: Colors.white,
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          );
                        },
                      )
                          : Icon(
                        Icons.error,
                        size: 40.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                    SizedBox(width: 10.w,),
                  Expanded(
                    child: Text(
                      category.name ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

    }
  }

}