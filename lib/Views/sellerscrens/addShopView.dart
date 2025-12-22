import 'package:ecommercefrontend/View_Model/SellerViewModels/addShopViewModel.dart';
import 'package:ecommercefrontend/Views/sellerscrens/widgets/selectLocationDropDown.dart';
import 'package:ecommercefrontend/core/utils/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/utils/notifyUtils.dart';
import 'addAccountView.dart';
import 'widgets/ShopCategoryDropDownMenu.dart';
import '../../core/utils/colors.dart';

class addShopView extends ConsumerStatefulWidget {
  int id;
  addShopView({required this.id});

  @override
  ConsumerState<addShopView> createState() => _addShopViewState();
}

class _addShopViewState extends ConsumerState<addShopView> {
  final formkey = GlobalKey<FormState>();
  final TextEditingController shopname = TextEditingController();
  final TextEditingController shopaddress = TextEditingController();
  final TextEditingController delivery = TextEditingController();
  final TextEditingController city = TextEditingController();


  @override
  void dispose() {
    shopname.dispose();
    shopaddress.dispose();
    city.dispose();
    delivery.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addShopProvider(widget.id.toString()));
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Appcolors.whiteSmoke,
      ),
      backgroundColor: Appcolors.whiteSmoke,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Form(
            key: formkey,
            child: Column(
              spacing: 8.h,
              children: [
                if(state.images.isEmpty)
                  InkWell(
                    onTap: () {
                      ref
                          .read(addShopProvider(widget.id.toString()).notifier)
                          .pickImages(context);
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
                                  ref
                                      .read(
                                        addShopProvider(
                                          widget.id.toString(),
                                        ).notifier,
                                      )
                                      .removeImage(index);
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                ],

                TextFormField(
                  controller: shopname,
                  decoration: InputDecoration(
                      labelText: "Shop Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0.r),
                    ),),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a Shop name";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: shopaddress,
                  decoration: InputDecoration(
                      labelText: "Shop Address",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0.r),
                    ),),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter address";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: delivery,
                  decoration: InputDecoration(
                      labelText: "Delivery charges",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0.r),
                    ),),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter delivery charges";
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                setShopAreaDropDown(userid: widget.id.toString()),
                TextFormField(
                  controller: city,
                  decoration: InputDecoration(
                      labelText: "city",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0.r),
                    ),),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter city";
                    }
                    return null;
                  },
                ),
                ShopcategoryDropdown(userid: widget.id.toString()),
                SizedBox(height: 8.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Payment Account",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18.sp)),
                    Text("  (Optional)",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 15.sp)),
                  ],
                ),
                addSellerAccount(userid: widget.id,),
                SizedBox(height: 8.h),
                InkWell(
                  onTap:state.isLoading
                      ? null
                      : () async {

                    if (formkey.currentState!.validate()) {
                   bool response =  await ref.read(
                        addShopProvider(
                          widget.id.toString(),
                        ).notifier,
                      )
                          .addShop(
                          shopname: shopname.text.trim(),
                          shopaddress: shopaddress.text.trim(),
                          city: city.text.trim(),
                          deliveryPrice:delivery.text.trim(),
                          userId:widget.id,
                          context: context
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
                        "Add Shop",
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
    await ref.read(addShopProvider(widget.id.toString()).notifier).Cancel(widget.id.toString(),context);
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
    "Back",
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
