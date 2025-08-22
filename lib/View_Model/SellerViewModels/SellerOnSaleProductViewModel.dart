import 'package:ecommercefrontend/models/ProductModel.dart';
import 'package:ecommercefrontend/repositories/onSaleRepository.dart';
import 'package:ecommercefrontend/repositories/product_repositories.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../SharedViewModels/getOnSaleProducts.dart';

//for seller to get and delete its onSaleProducts
final sellerOnSaleProductViewModelProvider = StateNotifierProvider.family<sellerOnSaleProductViewModel, AsyncValue<List<ProductModel?>>, String>((ref, id) {
  return sellerOnSaleProductViewModel(ref, id);
});

class sellerOnSaleProductViewModel extends StateNotifier<AsyncValue<List<ProductModel?>>> {
  final Ref ref;
  String id;
  sellerOnSaleProductViewModel(this.ref, this.id) : super(const AsyncValue.loading()) {
    getOnSaleProduct(id);
  }

  Future<void> getOnSaleProduct(String id) async {
    try {
      List<ProductModel?> product = await ref.read(productProvider).getUserOnSaleProducts(id);
      state = AsyncValue.data(product.isEmpty ? [] : product);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateOnSale(String id,int discount,DateTime expirationDateTime,BuildContext context) async {
    try {
      final data={
        'discountPercent':discount,
        'expire_at':expirationDateTime.toIso8601String(),
      };
      state =AsyncValue.loading();
      await ref.read(onSaleProvider).updateOnSaleProduct(id,data);
      ref.invalidate(onSaleViewModelProvider);
      await ref.read(onSaleViewModelProvider.notifier).getonSaleProduct("All");
      await getOnSaleProduct(this.id);
      Navigator.pop(context);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> deleteOnSaleProduct(String id) async {
    try {
      await ref.read(onSaleProvider).deleteOnSaleProduct(id);
      ref.invalidate(onSaleViewModelProvider);
      await ref.read(onSaleViewModelProvider.notifier).getonSaleProduct("All");
      await getOnSaleProduct(this.id); //Rerender Ui or refetch shops if shop deleted
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}