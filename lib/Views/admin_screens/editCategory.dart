import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:ecommercefrontend/models/categoryModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../View_Model/adminViewModels/editCategoryViewModel.dart';

class editCategory extends ConsumerStatefulWidget {

  final Category category;
  const editCategory({required this.category});

  @override
  ConsumerState<editCategory> createState() => _editCategoryState();
}

class _editCategoryState extends ConsumerState<editCategory> {

  final TextEditingController name=TextEditingController();
  String? status;
  @override
  void initState() {
    super.initState();
    print(widget.category.status);
    name.text = widget.category.name ?? "";
    status = widget.category.status ?? "";
  }

  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final model = ref.watch(editcategoryViewModelProvider);
    final key = GlobalKey<FormState>();


    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Category"),
        backgroundColor: Appcolors.whiteSmoke,
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
                  ref.read(editcategoryViewModelProvider.notifier).pickImages(context);
                },
                child: Container(
                  height: 200.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0.r),
                  ),
                  child: model.image != null
                      ?
                  Image.file(model.image!, fit: BoxFit.cover,)
                      :
                      widget.category.image != null && widget.category.image!.imageUrl != null
                  ?
                          CachedNetworkImage(imageUrl: widget.category.image!.imageUrl!)
                      :
                  Column(
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
              SizedBox(height: 10.h),
              DropdownButtonFormField<String>(
                value: status, // Ensure this matches one of the available items
                decoration: InputDecoration(
                  labelText: "Status",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0.r),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Field is required";
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    status = value!;
                  });
                },
                items: [
                  DropdownMenuItem(value: "Active", child: Text("Active")),
                  DropdownMenuItem(value: "Requested", child: Text("Requested")),
                ].where((item) => item != null).toList(),
              ),
              SizedBox(height: 32.h),
              ElevatedButton(
                onPressed:  () async {
                  await ref.read(editcategoryViewModelProvider.notifier).editCategory(widget.category.id.toString(),name.text.trim(),status!,context);

                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  backgroundColor: Appcolors.baseColor,
                ),
                child: Text("Save", style: TextStyle(fontSize: 16.sp,color: Appcolors.whiteSmoke, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}