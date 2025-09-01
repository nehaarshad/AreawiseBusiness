import 'dart:io';
import 'package:ecommercefrontend/View_Model/SharedViewModels/transacriptsStates.dart';
import 'package:ecommercefrontend/View_Model/buyerViewModels/OrderViewModel.dart';
import 'package:ecommercefrontend/repositories/transactionSlipRepository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

import '../../models/imageModel.dart';

final TranscriptsViewModelProvider = StateNotifierProvider<TranscriptsViewModel, transcriptsState>((ref,) {
  return TranscriptsViewModel(ref);
});

class TranscriptsViewModel extends StateNotifier<transcriptsState> {
  final Ref ref;
  TranscriptsViewModel(this.ref) : super(transcriptsState(isLoading: false));

  final ImagePicker pickImage = ImagePicker();
  File? uploadimage;

  Future<void> pickImages() async {
    final XFile? pickedimage = await pickImage.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedimage != null) {
      uploadimage = File(pickedimage.path);
      state = state.copyWith(adImage: uploadimage,isLoading: false);
    }
  }


  void resetState() {
    uploadimage = null;
    state = transcriptsState(isLoading: false, adImage: null);
  }
  ///for seller
  Future<void> getTranscript(int sellerId,int orderId) async {
    try {
      state=state.copyWith(isLoading: true);
      final data={
        "sellerId":sellerId,
        "orderId":orderId
      };
      List<ImageModel> image = await ref.read(transcriptsProvider).getTranscript(data);
      print(image[0].imageUrl);
      state = state.copyWith(isLoading: false,Image: image.last.imageUrl!.isEmpty ? null : image.last.imageUrl);
    } catch (e) {
      state = state.copyWith(isLoading: true);
    }
  }

  ///to send by buyer
  Future<void> uploadTranscript(int sellerId,int orderId,BuildContext context) async {

    try {
      final data={
        "sellerId":sellerId,
        "orderId":orderId
      };
      dynamic  response=await ref.read(transcriptsProvider).addTranscript(data,state.adImage);
      resetState();
      final message = response['message'] ?? 'false';
      print("Message ${message.runtimeType}");
   if(message=="true"){
     await ref.read(orderViewModelProvider.notifier).uploadTranscripts();
   }

   Navigator.pop(context,true);
    } catch (e) {
     print(e);

    }

  }
}