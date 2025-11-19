import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:ecommercefrontend/core/utils/dialogueBox.dart';
import 'package:ecommercefrontend/models/ProductModel.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShareProductIconButton extends ConsumerWidget {
  final ProductModel product;

  const ShareProductIconButton({Key? key,required this.product}) : super(key: key);

  final String playStoreLink = 'https://play.google.com/store/apps/details?id=com.intelaqt.ecommercefrontend';

  Future<void> shareProductWithLoading(BuildContext context) async {
    bool onSale= product.onSale!;
    int? price = onSale ? product.saleOffer!.price! :product.price;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          Center(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Appcolors.baseColor,),
                    SizedBox(height: 16),
                    Text('Preparing to share...'),
                  ],
                ),
              ),
            ),
          ),
    );

    try {
      List<XFile> imageFiles = [];
      final tempDir = await getTemporaryDirectory();

      for (int i = 0; i < product.images!.length; i++) {
        String imageUrl = product.images![i].imageUrl!;

        final response = await http.get(Uri.parse(imageUrl));

        if (response.statusCode == 200) {
          final file = File('${tempDir.path}/product_image_$i.jpg');
          await file.writeAsBytes(response.bodyBytes);
          imageFiles.add(XFile(file.path));
        }
      }
      Navigator.of(context).pop();

      String shareText = '''
🛍️ ${product.name}
${product.subtitle}
Description: ${product.description}

💰 Price: Rs.${price}

Check out this amazing product!
Download BizAroundU from Google Play Store: $playStoreLink
    ''';

      if (imageFiles.isNotEmpty) {
        await Share.shareXFiles(
          imageFiles,
          text: shareText,
          subject: product.name,
        );
      } else {
        await Share.share(shareText, subject: product.name);
      }
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();

      print("error sharing product $e");
      DialogUtils.showErrorDialog(context, "Failed to share product");
    }
  }

    @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () async {
           await shareProductWithLoading(context);
      },
      icon: Icon(Icons.share),
    );
  }
}



