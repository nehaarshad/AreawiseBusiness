import 'package:ecommercefrontend/Views/shared/widgets/colors.dart';
import 'package:ecommercefrontend/core/utils/routes/routes_names.dart';
import 'package:ecommercefrontend/models/shopModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../shared/widgets/imageSlider.dart';
import '../shared/widgets/shopProducts.dart';

class SellerShopDetailView extends ConsumerStatefulWidget {
  ShopModel shop;
  SellerShopDetailView({required this.shop});

  @override
  ConsumerState<SellerShopDetailView> createState() => _ShopDetailViewState();
}

class _ShopDetailViewState extends ConsumerState<SellerShopDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            //  mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageSlider(images: widget.shop.images ?? [], height: 350),
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(10, 15, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Text("${widget.shop.shopname}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black,)),
                    Text("${widget.shop.shopaddress} | ${widget.shop.city}",style: TextStyle(
                      fontWeight: FontWeight.normal,fontSize: 15, color: Colors.black87,),),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Text("Seller Name: ",style: TextStyle(color: Colors.blueGrey,fontSize: 15,fontWeight: FontWeight.w500),),
                        Text(
                          "${widget.shop.user?.username}",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Category: ",style: TextStyle(color: Colors.blueGrey,fontSize: 15,fontWeight: FontWeight.w500),),
                        Text(
                          "${widget.shop.category?.name}",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Sector: ",style: TextStyle(color: Colors.blueGrey,fontSize: 15,fontWeight: FontWeight.w500),),
                        Text(
                          "${widget.shop.sector}",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Divider()
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Shop Products",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        const Text("See All", style: TextStyle(color: Colors.grey)),
                        const Icon(Icons.arrow_forward_ios_sharp, size: 10),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              shopProducts(shopId:  widget.shop.id.toString()),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 22),
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.pushNamed(
              context,
              routesName.sAddProduct,
              arguments: widget.shop,
            );
          },
          icon: Icon(Icons.add, size: 18,color: Appcolors.whiteColor,),
          label: Text("Add Product"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Appcolors.blueColor,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}
