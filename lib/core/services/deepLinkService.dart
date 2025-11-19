import 'package:share_plus/share_plus.dart';
import '../../models/ProductModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DeepLinkService {
  static const String deepLinkDomain = 'n8n.intelaqtglobal.com';
  static const String appScheme = 'intelaqt';
  //static const String backendBaseUrl = 'https://n8n.intelaqtglobal.com';
  static const String backendBaseUrl = 'http://10.113.136.179:5000';
  // Share product using backend-generated deep link
  static Future<void> shareProduct(ProductModel product) async {
    try {
      // Generate deep link from backend
      final response = await http.post(
        Uri.parse('$backendBaseUrl/api/generate-deeplink'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'productId': product.id,
          'productName': product.name,
          'description': product.description,
        }),
      );
       print("response on post share product: ${response}");
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await Share.share(data['message']);
      } else {
        // Fallback if backend fails
        await _shareWithFallback(product);
      }
    } catch (e) {
      print('Error generating deep link: $e');
      // Fallback if backend fails
      await _shareWithFallback(product);
    }
  }

  // Fallback method
  static Future<void> _shareWithFallback(ProductModel product) async {
    final String deepLink = 'https://$deepLinkDomain/deeplink/product/${product.id}';
    final String playStoreLink = 'https://play.google.com/store/apps/details?id=com.intelaqt.ecommercefrontend';

    final String message = '''
Check out ${product.name}!

${product.description ?? ''}

Open in app: $deepLink

Or download from Play Store: $playStoreLink
''';

    await Share.share(message);
  }

  // Test deep link generation
  static Future<Map<String, dynamic>> testDeepLinkGeneration(ProductModel product) async {
    try {
      final response = await http.post(
        Uri.parse('$backendBaseUrl/api/generate-deeplink'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'productId': product.id,
          'productName': product.name,
          'description': product.description,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to generate deep link: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}