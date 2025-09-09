import 'dart:async';
import 'dart:io';
import 'package:ecommercefrontend/View_Model/adminViewModels/userState.dart';
import 'package:ecommercefrontend/models/NewArrivalDuration.dart';
import 'package:ecommercefrontend/models/deliveryOrderAttributes.dart';import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/notifyUtils.dart';
import 'package:flutter/material.dart';
import '../../repositories/deliveryOrderAttributesRepository.dart';
import '../../repositories/product_repositories.dart';
import '../SharedViewModels/NewArrivalsViewModel.dart';
import '../SharedViewModels/productViewModels.dart';


final attributesViewModelProvider = StateNotifierProvider<attributesViewModel,AsyncValue<DeliveryOrderAttributes>>((ref) {
  return attributesViewModel(ref);
});

class attributesViewModel extends StateNotifier<AsyncValue<DeliveryOrderAttributes>> {
  final Ref ref;
  attributesViewModel(this.ref) : super(AsyncValue.loading()) {
    initValues();
  }


  final key = GlobalKey<FormState>();
   TextEditingController shippingPrice=TextEditingController();
   TextEditingController discount=TextEditingController();
   TextEditingController total=TextEditingController();
  TextEditingController duration=TextEditingController();


  void initValues() async {
    try {
      DeliveryOrderAttributes attributes  = await ref.read(attributesProvider).getAttributes();

      discount.text = attributes.discount.toString().split('.')[1];
      shippingPrice.text = attributes.shippingPrice!.toString();
      total.text = attributes.totalBill.toString();
      NewArrivalDuration days = await ref.read(productProvider).getArrivalDuration();
      print(days);

      duration.text = days.day.toString();
      print("Discount conversion ${discount.text}");
      state = AsyncValue.data(attributes);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> getAttributes() async {
    try {
      DeliveryOrderAttributes attributes = await ref.read(attributesProvider).getAttributes();
      state = AsyncValue.data(attributes);
      shippingPrice = TextEditingController(text: attributes.shippingPrice!.toString());
      discount = TextEditingController(text: attributes.discount.toString());
      total = TextEditingController(text: attributes.totalBill.toString());
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      print('Error loading categories: $e');
    }
  }
  Future<void> getDays() async {
    try {
      NewArrivalDuration days = await ref.read(productProvider).getArrivalDuration();
      duration = TextEditingController(text: days.day.toString());
      Utils.toastMessage("Updated Successfully!");

    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      print('Error loading categories: $e');
      return null;
    }
  }
  Future<void> updateDuration(  Map<String, dynamic> data,  BuildContext context,) async {
    try {
      await ref.read(productProvider).updateArrivalDuration(data);
      Utils.toastMessage("Updated Successfully!");
      getDays();
      ref.invalidate(sharedProductViewModelProvider);
      await ref.read(newArrivalViewModelProvider.notifier).getNewArrivalProduct('All');
      await ref.read(sharedProductViewModelProvider.notifier).getAllProduct('All');
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      print('Error loading categories: $e');
    }
  }
  Future<void> updateAttributes(  Map<String, dynamic> data,  BuildContext context,) async {
    try {

      dynamic attributes = await ref.read(attributesProvider).updateAttributes(data);
      Utils.toastMessage("Updated Successfully!");
     getAttributes();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      print('Error loading categories: $e');
    }
  }

}
