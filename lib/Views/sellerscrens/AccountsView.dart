import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../View_Model/SellerViewModels/paymentAccountViewModel.dart';
import '../../core/utils/colors.dart';
import '../../core/utils/routes/routes_names.dart';

class SellerAccountsView extends ConsumerStatefulWidget {
  final int userid;
  const SellerAccountsView({super.key,required this.userid});

  @override
  ConsumerState<SellerAccountsView> createState() => _SellerAccountsViewState();
}

class _SellerAccountsViewState extends ConsumerState<SellerAccountsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(sellerPaymentAccountViewModelProvider(widget.userid.toString()).notifier).getPaymentAcconts(widget.userid.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final accounts = ref.watch(sellerPaymentAccountViewModelProvider(widget.userid.toString()));

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap:()async{
                Navigator.pushNamed(
                  context,
                  routesName.addAccount,
                  arguments: widget.userid,
                );
              },
              child: Container(
                height: 25.h,
                width: 100.w,
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
                    "Add Account",
                    style: TextStyle(
                      color: Appcolors.baseColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body:Consumer(
            builder: (context, ref, child) {
              return accounts.when(
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: LinearProgressIndicator(color: Appcolors.baseColor),
                  ),
                ),
                data: (products) {
                  if (products.isEmpty) {
                    return  Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Center(
                          child: Column(
                            children: [
                              Text("Account Setup Required",style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.bold,color: Appcolors.baseColor),),
                              SizedBox(height: 20.h,),
                              Text("You haven't added any payment accounts to receive online transactions for products ordered. Add your accounts to start selling your products and receiving payments.",
                                style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.normal,color: Appcolors.blackColor),),
                            ],
                          ),
                        ),
                      );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      if (product == null) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.all(10),
                                  leading: Icon(Icons.account_balance_wallet,color: Appcolors.baseColor,size: 25.h,),
                                  title: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 28.0.w),
                                    child: Text(
                                      product.accountHolderName ?? 'No Name',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                       "Account Type: ${product.accountType}",
                                        style:  TextStyle(fontSize: 12.h),
                                      ),
                                        Text(
                                          "Account N0. ${product.accountNumber}",
                                          style:  TextStyle(fontSize: 12.h),
                                        ),
                                      if(product.accountType=="bankAccount")

                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Bank: ${product.bankName}",
                                              style:  TextStyle(fontSize: 12.h),
                                            ),
                                            Text(
                                              "IBAN: ${product.IBAN}",
                                              style:  TextStyle(fontSize: 12.h),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                  trailing:  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () async {
                                      if (product.id != null) {
                                        await ref.read(sellerPaymentAccountViewModelProvider(widget.userid.toString()).notifier)
                                            .deletePaymentAcconts(product.id.toString());
                                      }
                                    },
                                    tooltip: "Delete Product",
                                  ),
                                ),
                                Divider(height: 1.h),

                              ],
                            ),
                      );

                    },
                  );
                },
                error: (error, stackTrace) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red, size: 48.h),
                        SizedBox(height: 16.h),
                        Text('Error loading products: ${error.toString()}'),

                      ],
                    ),
                  ),
                ),
              );
            },
          ),

    );
  }
}
