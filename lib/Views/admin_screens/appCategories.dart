import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../View_Model/adminViewModels/categoriesViewModel.dart';
import '../../core/utils/routes/routes_names.dart';
import '../../core/utils/textStyles.dart';
import '../../models/categoryModel.dart';
import '../../core/utils/colors.dart';
import '../shared/widgets/loadingState.dart';

class AllCategories extends ConsumerStatefulWidget {
  const AllCategories({super.key});

  @override
  ConsumerState<AllCategories> createState() => _AllCategoriesState();
}

class _AllCategoriesState extends ConsumerState<AllCategories> {
  final TextEditingController _categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(categoryViewModelProvider.notifier).getCategories();
    });
  }
  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoryViewModelProvider);

    return Scaffold(
      backgroundColor: Appcolors.whiteSmoke,
      appBar: AppBar(
        title:  Text(
          ' Categories',
          style: AppTextStyles.headline
        ),
        backgroundColor: Appcolors.whiteSmoke,
        actions: [ TextButton(onPressed: (){
          Navigator.pushNamed(context, routesName.addCategory);
        }, child: Padding(
          padding:  EdgeInsets.only(right: 5.0),
          child: Text("+ Add"),
        ))],
      ),
      body: categoriesAsync.isLoading ? const Column(
        children: [
          ShimmerListTile(),
          ShimmerListTile(),
          ShimmerListTile(),
          ShimmerListTile(),
        ],
      ): (categoriesAsync.category != null)
          ? Categories(categoriesAsync.category)
          : SizedBox.shrink()

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
       itemBuilder: (context, index) {
         final category = categories[index];
         if (category == null || category.name =="All") return SizedBox.shrink();
         print(category.image?.imageUrl);
         return Padding(
             padding: const EdgeInsets.all(8.0),
             child: Column(
               children: [
                 ListTile(
                   onTap: () {
                     Navigator.pushNamed(
                       context,
                       routesName.subcategories,
                       arguments:category,
                     );
                   },

                   leading: (category.image != null && category.image!.imageUrl!.isNotEmpty)
                       ? CachedNetworkImage(
                   imageUrl:   category.image!.imageUrl!,
                     fit: BoxFit.cover,
                     width: 50.w,
                     height: 50.h,
                     errorWidget: (context, error, stackTrace) {
                       return const Icon(Icons.error);
                     },
                   )
                       : const Icon(Icons.image_not_supported),
                   title: Text("${category.name}",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18.sp),),
                   subtitle: Text("${category.status}",style: TextStyle(color: category.status == 'Active'?Appcolors.baseColor:Colors.deepOrange,fontWeight: FontWeight.w600),) ,

                   trailing: Row(
                     mainAxisSize: MainAxisSize.min,
                     children: [
                       IconButton(
                         onPressed: (){
                           Navigator.pushNamed(context, routesName.editCategory,arguments: category);
                         },
                         icon: Icon(Icons.edit, size: 20.h,color: Appcolors.baseColor,),),
                       IconButton(
                         onPressed: (){
                           DeleteDialogBox(category);
                         },
                         icon: Icon(Icons.delete, size: 20.h,color: Colors.red,),),
                     ],
                   ),
                 ),
               ],
             ),
           );

       },
     );
   }
  }


  void DeleteDialogBox(Category category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title:  Text(
          'Delete Category',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${category.name}"? ',
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
             await ref.read(categoryViewModelProvider.notifier)
                  .deleteCategory(category.id.toString());
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