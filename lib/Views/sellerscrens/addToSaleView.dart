import 'package:ecommercefrontend/Views/sellerscrens/widgets/productsDropDown.dart';
import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:ecommercefrontend/core/utils/notifyUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../View_Model/SellerViewModels/createFeatureProductViewModel.dart';
import '../shared/widgets/SetDateTime.dart';

class createNewSaleView extends ConsumerStatefulWidget {
  final int userid;
  const createNewSaleView({super.key, required this.userid});

  @override
  ConsumerState<createNewSaleView> createState() => _createNewSaleViewState();
}

class _createNewSaleViewState extends ConsumerState<createNewSaleView> {
  final TextEditingController discount = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    discount.dispose();
    super.dispose();
  }

  Future<void> addToSale(BuildContext context) async {
    final DateTime? selectedDateTime = await setDateTime(context);
    if (selectedDateTime != null) {
      ref.read(createfeatureProductViewModelProvider(widget.userid.toString()).notifier)
          .selectExpirationDateTime(selectedDateTime);
    }
  }

  void onSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {

      final discountValue = int.tryParse(discount.text);
      if (discountValue == null || discountValue <= 0 || discountValue > 100) {
        Utils.flushBarErrorMessage("Please enter a valid discount percentage (1-100)", context);
        return;
      }

      await ref.read(createfeatureProductViewModelProvider(widget.userid.toString()).notifier)
          .addOnSale(
        widget.userid.toString(),
        discountValue,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       leading: IconButton(onPressed: ()async{
          ref.read(createfeatureProductViewModelProvider(widget.userid.toString()).notifier).resetState();
         Navigator.pop(context);
       }, icon: Icon(Icons.arrow_back,color: Appcolors.whiteSmoke,)),
        title: Text('Create New Sale',style: TextStyle(color: Appcolors.whiteSmoke),),
        backgroundColor: Appcolors.baseColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 24.h),

                TextFormField(
                  controller: discount,
                  decoration: InputDecoration(
                    labelText: "Discount Offer (%)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0.r),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter discount percentage";
                    }
                    final discountValue = int.tryParse(value);
                    if (discountValue == null || discountValue <= 0 || discountValue > 100) {
                      return "Please enter a valid discount percentage (1-100)";
                    }
                    return null;
                  },
                ),

                UserProductsDropdown(userid: widget.userid.toString()),

                SizedBox(height: 24.h),
                Text(
                  "Select Expiration Date & Time",
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.h),

                Consumer(
                  builder: (context, ref, child) {
                    final addToSaleState = ref.watch(createfeatureProductViewModelProvider(widget.userid.toString()));

                    return GestureDetector(
                      onTap: () => addToSale(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                addToSaleState.expirationDateTime != null
                                    ? "${addToSaleState.expirationDateTime!.day}/${addToSaleState.expirationDateTime!.month}/${addToSaleState.expirationDateTime!.year} at ${addToSaleState.expirationDateTime!.hour}:${addToSaleState.expirationDateTime!.minute.toString().padLeft(2, '0')}"
                                    : "Select Date and Time",
                                style: TextStyle(
                                  color: addToSaleState.expirationDateTime != null
                                      ? Colors.black
                                      : Colors.grey[600],
                                ),
                              ),
                            ),
                            Icon(Icons.calendar_today, color: Appcolors.baseColor),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 32.h),

                Consumer(
                  builder: (context, ref, child) {
                    final addToSaleState = ref.watch(createfeatureProductViewModelProvider(widget.userid.toString()));

                    return ElevatedButton(
                      onPressed: addToSaleState.isLoading ? null : onSubmit,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        backgroundColor: Appcolors.baseColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0.r),
                        ),
                      ),
                      child: addToSaleState.isLoading
                          ? CircularProgressIndicator(color: Appcolors.whiteSmoke)
                          : Text(
                        "Post",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Appcolors.whiteSmoke,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}