import 'package:ecommercefrontend/Views/shared/widgets/colors.dart';
import 'package:ecommercefrontend/core/utils/routes/routes_names.dart';
import 'package:ecommercefrontend/models/shopModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../widgets/imageSlider.dart';
import '../widgets/shopProducts.dart';

class ShopDetailView extends ConsumerStatefulWidget {
  ShopModel shop;
  ShopDetailView({required this.shop});

  @override
  ConsumerState<ShopDetailView> createState() => _ShopDetailViewState();
}

class _ShopDetailViewState extends ConsumerState<ShopDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ImageSlider(images: widget.shop.images ?? [], height: 350),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.fromLTRB(10, 15, 20, 100),
                child: Column(
                      children: [
                        SizedBox(height: 10),
                        Text("${widget.shop.shopname}", style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.black,
                          )),
                        SizedBox(height: 15),
                        Text("${widget.shop.category?.name}", style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black,
                          )),
                        SizedBox(height: 10),
                        Text("${widget.shop.shopaddress}", style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Products", style: TextStyle(
                        color: Appcolors.blackColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("See All", style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              shopProducts(shopId:  widget.shop.id.toString()),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(100, 0, 100, 100),
        child: SizedBox(
          height: 50.0,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, routesName.sAddProduct, arguments: widget.shop,);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Appcolors.blueColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
            ),
            child: const Text(
              "Add New Product",
              style: TextStyle(
                color: Appcolors.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
