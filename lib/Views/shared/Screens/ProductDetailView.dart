import 'package:ecommercefrontend/View_Model/buyerViewModels/WishListViewModel.dart';
import 'package:ecommercefrontend/View_Model/buyerViewModels/cartViewModel.dart';
import 'package:ecommercefrontend/Views/shared/widgets/colors.dart';
import 'package:ecommercefrontend/core/utils/utils.dart';
import 'package:ecommercefrontend/models/ProductModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/routes/routes_names.dart';
import '../widgets/imageSlider.dart';
import '../widgets/wishListButton.dart';

class productDetailView extends ConsumerStatefulWidget {
  int userid;
  ProductModel product;

  productDetailView({required this.userid, required this.product});

  @override
  ConsumerState<productDetailView> createState() => _productDetailViewState();
}

class _productDetailViewState extends ConsumerState<productDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         actions: [
           WishlistButton( userId: widget.userid.toString(),product:widget.product),
         ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ImageSlider(images: widget.product.images ?? [], height: 350),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40),
                  ),
                ),
                padding: EdgeInsets.fromLTRB(10, 15, 20, 100),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Column(
                      children: [
                        Text("${widget.product.name}",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black,),),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "\$${widget.product.price}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                await ref.read(cartViewModelProvider(widget.userid.toString(),).notifier,)
                                    .addToCart(widget.userid.toString(), widget.product.id!,);
                                Utils.toastMessage("Added Successfully!");
                              },
                              child: Container(
                                width: 70,
                                height: 35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.deepOrange,
                                ),
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Icon(
                                  Icons.shopping_cart_outlined,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 5),
                        Text(
                          "${widget.product.category?.name}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                child: Text(
                                  "${widget.product.description}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
