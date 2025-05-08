import 'package:ecommercefrontend/View_Model/buyerViewModels/WishListViewModel.dart';
import 'package:ecommercefrontend/View_Model/buyerViewModels/cartViewModel.dart';
import 'package:ecommercefrontend/Views/shared/widgets/colors.dart';
import 'package:ecommercefrontend/core/utils/utils.dart';
import 'package:ecommercefrontend/models/ProductModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/routes/routes_names.dart';
import '../widgets/DashBoardProductsView.dart';
import '../widgets/contactWithSellerButton.dart';
import '../widgets/imageSlider.dart';
import '../widgets/productReviews.dart';
import '../widgets/relatedProducts.dart';
import '../widgets/wishListButton.dart';

class productDetailView extends ConsumerStatefulWidget {
  int userid;
  ProductModel product;

  productDetailView({required this.userid, required this.product});

  @override
  ConsumerState<productDetailView> createState() => _productDetailViewState();
}

class _productDetailViewState extends ConsumerState<productDetailView> {

  int Qty=1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         actions: [
           Row(
             children: [
               WishlistButton( userId: widget.userid.toString(),product:widget.product),
               contactWithSellerButton(
                 userId: widget.userid.toString(),
                 productId: widget.product.id.toString(),
                 product: widget.product,
               ),
             ],
           ),
         ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ImageSlider(images: widget.product.images ?? [], height: 350),

              SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.fromLTRB(10, 15, 10, 100),
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.store,color: Colors.grey,),
                              Text('${widget.product.shop?.shopname!}',style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15
                              ),)
                            ],
                          ),
                          Divider(thickness: 0.4,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${widget.product.name}",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black,),),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text("Rs.",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w400),),
                                  Text("${widget.product.price}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20,
                                      color: Appcolors.blueColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 3),
                          Text("${widget.product.subtitle}",style: TextStyle(
                            fontWeight: FontWeight.normal,fontSize: 15, color: Colors.black87,),),
                          SizedBox(height: 10),
                          Row(
                                children: [
                                  Text("Sold: ",style: TextStyle(color: Colors.blueGrey,fontSize: 15,fontWeight: FontWeight.w500),),
                                  Text(
                                    "${widget.product.sold}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(" (${widget.product.stock} available)",style: TextStyle(color: Colors.red,fontSize: 15,fontWeight: FontWeight.w500),),

                                ],
                              ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text("Qty: ",style: TextStyle(color: Colors.blueGrey,fontSize: 15,fontWeight: FontWeight.w500),),
                              Container(
                                height: 35,
                                width: 124,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey, width: 1),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: BoxConstraints(),
                                      iconSize: 20,
                                      onPressed: (Qty > 1)
                                          ? () {
                                       setState(() {
                                         Qty = Qty - 1;
                                       });
                                        if (kDebugMode) {
                                          print("Decrement to: $Qty in product View");
                                        }
                                      }
                                          : null,
                                      icon: const Icon(Icons.remove),
                                    ),
                                    Text(
                                      '$Qty',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: BoxConstraints(),
                                      iconSize: 20,
                                      onPressed: (widget.product.stock != null && Qty < widget.product.stock!)
                                          ? () {
                                        setState(() {
                                          Qty = Qty + 1;
                                        });
                                        if (kDebugMode) {
                                          print("Increment to: $Qty in productView");
                                        }
                                      }
                                          : null,
                                      icon: const Icon(Icons.add, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              )

                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text("Category: ",style: TextStyle(color: Colors.blueGrey,fontSize: 15,fontWeight: FontWeight.w500),),
                                  Text(
                                    "${widget.product.subcategory?.name}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 60,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.deepOrange,
                                ),
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    Text('${widget.product.ratings}',style: TextStyle(color: Colors.white,fontSize: 15)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Product Description: ",
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextSpan(
                                  text: widget.product.description,
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 15,
                                    wordSpacing: 5,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          ProductReviews(productId: widget.product.id!,userId: widget.userid,),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8,),
                                child: Text(
                                  "Related Products",
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                              ),
                              Row(
                                children: [
                                  const Text("See All", style: TextStyle(color: Colors.grey)),
                                  const Icon(Icons.arrow_forward_ios_sharp, size: 10),
                                ],
                              ),
                            ],
                          ),
                          RelatedProducts(userid: widget.userid,category: widget.product.category!.name,),
                            ],
                          ),


                ),
              ),
            ],
          ),
        ),
      ),
    bottomNavigationBar: Padding(
    padding: const EdgeInsets.all(12.0),
    child: SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton.icon(
    onPressed: () async {
    await ref.read(cartViewModelProvider(widget.userid.toString()).notifier)
        .addToCart(widget.userid.toString(), widget.product.id!,Qty);
    Utils.toastMessage("Added Successfully!");
    },
    style: ElevatedButton.styleFrom(
    backgroundColor: Appcolors.blueColor,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(30),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 20),
    ),
    icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
    label: const Text(
    'Add to Cart',
    style: TextStyle(color: Colors.white, fontSize: 16),
    ),
    ),
    ),
    )
    );
  }
}
