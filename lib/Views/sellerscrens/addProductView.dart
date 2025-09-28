import 'package:ecommercefrontend/View_Model/SellerViewModels/addProductViewModel.dart';
import 'package:ecommercefrontend/Views/sellerscrens/widgets/productCondition.dart';
import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'widgets/ProductCateASubCategoryDropdownMenu.dart';
import 'widgets/shopsDropDown.dart';

class addProductView extends ConsumerStatefulWidget {
  String userId;
  addProductView({required this.userId});

  @override
  ConsumerState<addProductView> createState() => _addProductViewState();
}

class _addProductViewState extends ConsumerState<addProductView> {

  ProductCondition condition = ProductCondition.New;


  late final AddProductViewModel _viewModel;
  final formkey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController subtitle = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController stock = TextEditingController();


  @override
  void dispose() {
    name.dispose();
    subtitle.dispose();
    description.dispose();
    price.dispose();
    stock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String userid=widget.userId.toString();

    print("userid: ${userid} with type: ${userid.runtimeType}");
    final state = ref.watch(addProductProvider(userid));
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading:false,
        backgroundColor: Appcolors.whiteSmoke,
      ),
      backgroundColor: Appcolors.whiteSmoke,

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Form(
            key: formkey,
            child: Column(
              spacing: 10.h,
              children: [

                if(state.images.isEmpty)
                  InkWell(
                    onTap: () {
                      ref.read(addProductProvider(userid).notifier).pickImages(context);

                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0.r),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.upload, size: 50.h, color: Colors.grey[600]),
                          SizedBox(height: 8),
                          Text("Tap to upload image", style: TextStyle(color: Colors.grey[600]),),
                        ],
                      ),
                      height: 200.h,
                      width: 400.w,
                      //  width: 250.w,
                    ),
                  ),
                if (state.images.isNotEmpty) ...[
                  SizedBox(
                    height: 150.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.images.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 130.w, // Define explicit width
                                height: 150.h, // Define explicit height
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: Image.file(
                                    state.images[index],
                                    fit: BoxFit.cover, // Important for proper display
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: IconButton(
                                icon: Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  ref.read(addProductProvider(userid).notifier).removeImage(index);
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  InkWell(
                    onTap:(){
                      ref.read(addProductProvider(userid).notifier).pickImages(context);
                    },
                    child: Container(
                      height: 30.h,
                      margin: EdgeInsets.symmetric(horizontal: 25.w),
                      width: 130.w,
                      decoration: BoxDecoration(
                        color: Appcolors.whiteSmoke,
                        borderRadius: BorderRadius.circular(25.r),
                        border: Border.all(  // Use Border.all instead of boxShadow for borders
                          color: Appcolors.baseColor,
                          width: 1.0,  // Don't forget to specify border width
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Upload Images",
                          style: TextStyle(
                            color: Appcolors.baseColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                TextFormField(
                  controller: name,
                  decoration: InputDecoration(labelText: "Product Name",border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0.r),
                  ),),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a product name";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: price,
                  decoration: InputDecoration(labelText: "Price",border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0.r),
                  ),),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a price";
                    }
                    return null;
                  },
                ),
                TextFormField(
                    controller: subtitle,
                    decoration: InputDecoration(labelText: "Subtitle",border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0.r),
                    ),),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Provide subtitle of a product";
                      }
                      return null;
                    },
                ),
                TextFormField(
                  controller: description,
                  decoration: InputDecoration(labelText: "Description",border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0.r),
                  ),),
                  maxLines: 3,
                  maxLength: 500,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a description";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: stock,
                  decoration: InputDecoration(labelText: "Stock",
                    border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0.r),
                  ),),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter stock quantity";
                    }
                    return null;
                  },
                ),
                Row(
                  children: [
                    Text('Product Condition', style: TextStyle(fontWeight: FontWeight.w400)),
                    SizedBox(width: 30.w,),
                    Radio(
                      value: ProductCondition.New,
                      groupValue: condition,
                      onChanged: ( value) {
                        setState(() {
                          condition = value!;
                        });
                      },
                    ),
                    Text('New'),
                    SizedBox(width: 15),
                    Radio(
                      value: ProductCondition.Used,
                      groupValue: condition,
                      onChanged: ( value) {
                        setState(() {
                          condition = value!;
                        });
                      },
                    ),
                    Text('Used'),
                  ],
                ),
                ProductCategoryDropdown(shopid: userid),
                ProductSubcategoryDropdown(userId:userid),
                ActiveUserShopDropdown(userid:userid),
                SizedBox(height: 10),
                InkWell(
                  onTap:state.isLoading ? null : () async {
                    if (formkey.currentState!.validate()) {
                      condition==ProductCondition.New ?'New':"Used";
                    bool response=  await ref.read(addProductProvider(userid).notifier,)
                          .addProduct(
                        name: name.text,
                        price: price.text,
                        subtitle:subtitle.text,
                        description: description.text,
                        stock: stock.text,
                        user:widget.userId.toString(),
                        condition:condition.value,
                        context: context,
                      );
                    if(response){

                      Navigator.pop(context);
                    }
                    }
                  },
                  child: Container(
                    height: 40.h,
                    margin: EdgeInsets.symmetric(horizontal: 25.w),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Appcolors.baseColor,
                      borderRadius: BorderRadius.circular(15.r),

                    ),
                    child: Center(
                      child:state.isLoading
                          ? CircularProgressIndicator(color: Appcolors.whiteSmoke,)
                          : Text(
                        "Add Product",
                        style: TextStyle(
                          color: Appcolors.whiteSmoke,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
                  ),
                ),

                InkWell(
                  onTap:()async{
                    await ref.read(addProductProvider(widget.userId.toString()).notifier).Cancel(widget.userId.toString(),context);
                  },
                  child: Container(
                    height: 40.h,
                    margin: EdgeInsets.symmetric(horizontal: 25.w),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Appcolors.whiteSmoke,
                      borderRadius: BorderRadius.circular(15.r),
                      border: Border.all(  // Use Border.all instead of boxShadow for borders
                        color: Appcolors.baseColor,
                        width: 1.0,  // Don't forget to specify border width
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Appcolors.baseColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
