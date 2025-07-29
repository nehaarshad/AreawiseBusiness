import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:ecommercefrontend/core/utils/textStyles.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../View_Model/adminViewModels/ShopViewModel.dart';
import '../../core/utils/routes/routes_names.dart';
import '../../models/shopModel.dart';
import '../shared/widgets/searchShop.dart';

class allShopsView extends ConsumerStatefulWidget {
  int id;//userId
  allShopsView({required this.id});

  @override
  ConsumerState<allShopsView> createState() => _AllShopsViewState();
}

class _AllShopsViewState extends ConsumerState<allShopsView> {

  @override
  void initState() {
    super.initState();
    print("UserId in admin allShopView ${widget.id}");
  }

  List<ShopModel?> ShopList=[];
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
         actions: [
          searchShop(id:widget.id,myShop: true,),
         ]
      ),
      backgroundColor: Appcolors.whiteColor,
      body: ListView(
        children:[ Consumer(
            builder: (context,ref, child){
              final shopState = ref.watch(shopViewModelProvider);
              return shopState.when(

                  loading: () => const Center(child: CircularProgressIndicator(color: Appcolors.blueColor)),
                  data: (shops) {
                    ShopList=shops;
                    if (shops.isEmpty) {
                      return const Center(child: Text("No Shops Available"));
                    }
                    return ListView.builder(
                      itemCount: shops.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final shop = shops[index];
                        if(shop==null){
                          return SizedBox.shrink();
                        }
                        return  InkWell(
                            onTap: () {
                              final parameters={
                                'shop':shop,
                                'id':widget.id
                              };
                              Navigator.pushNamed(
                                context,
                                routesName.SellerShopDetailView,
                                arguments: parameters,
                              );
                            },
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(shop?.shopname ?? 'No Name'),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        shop?.category?.name ?? 'No Category',
                                        style:  TextStyle(fontSize: 12.sp),
                                      ),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          final parameters={
                                            'shopid':shop!.id,
                                            'userid':widget.id.toString(),
                                          };
                                          Navigator.pushNamed(
                                            context,
                                            routesName.sEditShop,
                                            arguments: parameters,
                                          );
                                        },
                                        icon: Icon(Icons.edit, color: Appcolors.blueColor),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () async {
                                          await ref.read(shopViewModelProvider.notifier)
                                              .deleteShop(shop.id.toString(),shop.userId.toString());

                                        },
                                      ),
                                    ],
                                  ),
                                ),
                               // Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 20.w),
                                      child: Container(
                                        child: Text(
                                         "Status: ${  shop?.status ?? "noStatus"}",
                                          style: TextStyle(
                                            color:  shop?.status == 'Active' ? Colors.green[800] : Colors.orange[800],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ),
                                    ),

                                    Padding(
                                          padding: EdgeInsets.only(right: 20.w),
                                          child: TextButton(
                                            onPressed: () async{
                                              final status = shop.status == 'Active' ? 'Dismiss' : 'Active';
                                              await ref.read(shopViewModelProvider.notifier).updateShopStatus(shop.id.toString(),shop.userId.toString(), status);

                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: shop.status == 'Active'
                                                  ? Colors.red[400]
                                                  : Colors.green[400],
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(40.0.r),
                                              ),
                                            ),
                                            child: Text(
                                              shop.status == 'Active' ? "Dismiss" : "Activate",
                                              style: TextStyle(
                                                color: Appcolors.whiteColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15.sp,
                                              ),
                                            ),
                                          ),
                                        ),

                                  ],
                                ),
                                Divider()
                              ],
                            ),
                          );

                      },
                    );
                  },
                  error: (error, stackTrace) => Center(child: Text('Error: ${error.toString()}')));
            }),
    ]
      )

    );
  }
}
