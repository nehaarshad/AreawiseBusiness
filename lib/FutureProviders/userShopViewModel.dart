import 'package:ecommercefrontend/models/shopModel.dart';
import 'package:ecommercefrontend/repositories/ShopRepositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getUserShopProvider = FutureProvider.family<List<ShopModel?>, String>((
  ref,
  id,
) async {
  List<ShopModel?> shop = await ref.watch(shopProvider).getUserShop(id);
  return shop;
});

final getAllShopProvider = FutureProvider<List<ShopModel?>>((ref) async {
  final shop = await ref.watch(shopProvider).getAllShops();
  return shop;
});

final deleteShopProvider = FutureProvider.family<void, String>((ref, id) async {
  await ref.watch(shopProvider).deleteShop(id);
});
