import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommercefrontend/Views/shared/widgets/loadingState.dart';
import 'package:ecommercefrontend/core/utils/textStyles.dart';
import 'package:ecommercefrontend/models/shopModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../View_Model/SellerViewModels/addProductViewModel.dart';
import '../../core/utils/colors.dart';
import '../../core/utils/routes/routes_names.dart';

class selectShop extends ConsumerStatefulWidget {
  final String id;
  const selectShop({required this.id});

  @override
  ConsumerState<selectShop> createState() => _selectShopState();
}

class _selectShopState extends ConsumerState<selectShop> {

  @override

  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(addProductProvider(widget.id).notifier).getUserShops();
    });
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(addProductProvider(widget.id).notifier).getUserShops();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final state=ref.watch(addProductProvider(widget.id));
    final model = ref.read(addProductProvider(widget.id).notifier);
    return Scaffold(
        appBar: AppBar(
          title: Text("Select your shop",style: AppTextStyles.headline,),

        ),
        body: state.isLoading ? const Column(
          children: [
            ShimmerListTile(),
            ShimmerListTile(),
            ShimmerListTile(),
            ShimmerListTile(),
          ],
        ): Shops(state.shops,widget.id)

    );
  }

  final ShopModel addNewShop= ShopModel(shopname: "Add New Shop",);

  Widget Shops(List<ShopModel?> shops,String? userid) {

    List<ShopModel?> updatedShops = [...shops];
    updatedShops.add(addNewShop);
    if(updatedShops == null ){
      return SizedBox.shrink();
    }
    if (updatedShops.isEmpty || updatedShops == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text("No Shop Yet!"),
        ),
      );
    }
    else{
      return ListView.builder(
        itemCount: updatedShops.length ,
        itemBuilder: (context, index) {
          final shop = updatedShops[index];
          if(shop==null){
            return SizedBox.shrink();
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ListTile(
                  onTap: () {

                      if(shop.shopname == "Add New Shop"){
                        Navigator.pushNamed(
                          context,
                          routesName.sAddShop,
                          arguments: int.tryParse(widget.id)
                        );
                      }
                      else {
                        final params={
                          "userId": widget.id,
                          "shopId":shop.id.toString(),

                        };
                        Navigator.pushNamed(
                            context,
                            routesName.sAddProduct,
                            arguments: params

                        );
                      }
                  },

                  leading: Container(
                    width: 60.w,
                    height: 60.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: (shop?.images != null &&
                        shop!.images!.isNotEmpty &&
                        shop.images!.first.imageUrl != null)
                        ? CachedNetworkImage(
                      imageUrl:  shop.images!.first.imageUrl!,
                      fit: BoxFit.cover,
                      errorWidget: (context, error, stackTrace) {
                        return const Icon(Icons.warehouse_outlined,color: Appcolors.baseColor,);
                      },
                    )
                        :  Icon(Icons.warehouse_outlined,color: Appcolors.baseColor, size: 25.h),
                  ),
                  title: Text("${shop.shopname}",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14.sp),),
                  subtitle:Text("${shop.status ?? ""}",style: TextStyle(color: shop.status == 'Active'? Appcolors.baseColor:Colors.deepOrange,fontWeight: FontWeight.w600),),
                  trailing: Icon(Icons.arrow_forward_ios_sharp, size: 12.h,color: Colors.grey,),

                ),
              ],
            ),
          );

        },
      );
    }
  }
}
