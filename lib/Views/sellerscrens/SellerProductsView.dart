import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../View_Model/SharedViewModels/productViewModels.dart';
import '../../core/utils/routes/routes_names.dart';
import '../shared/widgets/colors.dart';
import '../shared/widgets/getSellerAds.dart';
import '../shared/widgets/getUserProducts.dart';

class Sellerproductsview extends ConsumerStatefulWidget {
  final int id;
  const Sellerproductsview({required this.id});

  @override
  ConsumerState<Sellerproductsview> createState() => _SellerproductsviewState();
}

class _SellerproductsviewState extends ConsumerState<Sellerproductsview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(child: Text("My Products")),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 10),
            UserAdsView(sellerId: widget.id.toString()),
            getSellerProductView(sellerId: widget.id.toString()),
          ],
        ),
      ),
    );
  }
}