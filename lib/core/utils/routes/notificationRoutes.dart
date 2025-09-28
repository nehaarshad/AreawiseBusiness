import 'package:ecommercefrontend/core/utils/dialogueBox.dart';
import 'package:ecommercefrontend/core/utils/routes/routes_names.dart';
import 'package:ecommercefrontend/models/ProductModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../View_Model/SharedViewModels/productViewModels.dart';

Future<void> navigateBasedOnNotification({
  required String message,
  required int userId,
  required WidgetRef ref,
  required BuildContext context,
})
async {
  if (message.contains('request to feature product')) {
    await Navigator.pushNamed(context, routesName.featuredProducts, arguments: userId);
  }
  else if (message.contains('new request for product') && message.contains('Order #')) {
    await Navigator.pushNamed(context, routesName.OrderRequests, arguments: userId);
  }
  else if (message.contains('New product added to your shop')) {
    await Navigator.pushNamed(context, routesName.sProducts, arguments: userId);
  }
  else if (message.contains('New comment added on your product')) {
   String productName = extractProductNameFromComment(message);
 print("Search product ${productName}");
  ProductModel? product= await findProductByName(productName,userId,ref);
  if(product==null){
    await DialogUtils.showErrorDialog(context, "Product not found!");
    return;
  }
  final parameters={
    'id': userId,
    'productId':product.id,
    'product': product
  };
    await Navigator.pushNamed(context, routesName.productdetail, arguments: parameters);
  }
  else if (message.contains('Your ordered ')) {
    await Navigator.pushNamed(context, routesName.history, arguments: userId.toString());
    return;
  }
  else if (message.contains('new shop') && message.contains('has been created')) {
    await Navigator.pushNamed(context, routesName.sShop, arguments: userId);
  }
  else if (message.contains('Your shop') ) {
    await Navigator.pushNamed(context, routesName.sShop, arguments: userId);
  }
  else if (message.contains('Your product') && message.contains('has been updated') ) {
    await Navigator.pushNamed(context, routesName.sProducts, arguments: userId);
  }
  else if (message.contains('shop status has been updated')) {
    await Navigator.pushNamed(context, routesName.sShop, arguments: userId);
  }
  else if (message.contains('shop has been updated')) {
    await Navigator.pushNamed(context, routesName.sShop, arguments: userId);
  }
  else if (message.contains('Order #') && message.contains('has been placed successfully')) {
    await Navigator.pushNamed(context, routesName.history, arguments: userId.toString());

  }
  else {

  }
}

String extractProductNameFromComment(String message) {
    try {
// Pattern: "New comment added on your product {product name}"
   final regex = RegExp(r'New comment added on your product (.+)');
   final match = regex.firstMatch(message);

   if (match != null) {
    String productName = match.group(1)!.trim();

// Remove any trailing punctuation or symbols
   productName = productName.replaceAll(RegExp(r'[.,!?<>]$'), '');
   print("Product name in notification ${productName}");
   return productName;
   }
    return '';
} catch (e) {
return '';
}
}

 Future<ProductModel?> findProductByName(
String productName,
int userId,
WidgetRef ref,
) async
 {
try {
// Assuming you have a provider to get user's products
List<ProductModel?>? userProducts =  await ref.read(sharedProductViewModelProvider.notifier).getUserProduct(userId.toString());
if(userProducts==null || userProducts!.isEmpty){
  return null;
}
print(userProducts);
ProductModel? findProduct=null;

  for (final product in userProducts) {
    print(product?.name?.toLowerCase());
    print(productName.toLowerCase());
    if (product?.name?.toLowerCase().trim() == productName.toLowerCase().trim()) {
      findProduct = product;
      break;
    }
  }
print("Find product ${findProduct}");
return findProduct;
} catch (e) {
print('Error searching product: $e');
return null;
}
}