import 'package:ecommercefrontend/View_Model/adminViewModels/createAdViewModel.dart';
import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../View_Model/adminViewModels/categoriesViewModel.dart';
import '../../core/utils/routes/routes_names.dart';
import '../shared/widgets/SetDateTime.dart';

class addCategory extends ConsumerStatefulWidget {

  const addCategory();

  @override
  ConsumerState<addCategory> createState() => _addCategoryState();
}

class _addCategoryState extends ConsumerState<addCategory> {

  // @override
  // void initState() {
  //   super.initState();
  //   _viewModel.resetState();
  //
  //
  // }

  late final categoryViewModel _viewModel;

  final TextEditingController name=TextEditingController();
  @override
  void initState() {
    super.initState();
    Future.microtask(() { // Runs after build completes
      _viewModel = ref.read(categoryViewModelProvider.notifier);
    });
  }

  @override
  void dispose() {
    // Reset the state when the widget is disposed
    _viewModel.resetState();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final category = ref.watch(categoryViewModelProvider);
    final key = GlobalKey<FormState>();


    return Scaffold(
      appBar: AppBar(
        title: Text("Add Category"),
       backgroundColor: Appcolors.whiteColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Upload Section
              GestureDetector(
                onTap: () {
                  ref.read(categoryViewModelProvider.notifier).pickImages(context);
                },
                child: Container(
                  height: 200.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0.r),
                  ),
                  child: category.image != null ? Image.file(category.image!, fit: BoxFit.cover,) : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.upload, size: 50.h, color: Colors.grey[600]),
                      SizedBox(height: 8),
                      Text("Tap to upload image", style: TextStyle(color: Colors.grey[600]),),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              TextFormField(
                controller: name,
                decoration: InputDecoration(
                  labelText: "Category Name",
                  hintText: "Women Accessories",
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter username";
                  }
                  return null;
                },
              ),

              SizedBox(height: 32.h),
              ElevatedButton(
                onPressed: category.isLoading ? null : () async {
                  await ref.read(categoryViewModelProvider.notifier).addCategory(name.text.trim(),context);
                  name.text='';
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  backgroundColor: Colors.blue,
                ),
                child: category.isLoading ? CircularProgressIndicator(color: Appcolors.whiteColor, )
                    : Text("Submit", style: TextStyle(fontSize: 16.sp,color: Appcolors.whiteColor, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
