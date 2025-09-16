import 'dart:io';
import 'package:ecommercefrontend/View_Model/SharedViewModels/transacriptsStates.dart';
import 'package:ecommercefrontend/View_Model/buyerViewModels/OrderViewModel.dart';
import 'package:ecommercefrontend/repositories/transactionSlipRepository.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../../core/utils/notifyUtils.dart';
import '../../models/imageModel.dart';

final TranscriptsViewModelProvider = StateNotifierProvider<TranscriptsViewModel, transcriptsState>((ref,) {
  return TranscriptsViewModel(ref);
});

class TranscriptsViewModel extends StateNotifier<transcriptsState> {
  final Ref ref;
  TranscriptsViewModel(this.ref) : super(transcriptsState(isLoading: false));

  final ImagePicker pickImage = ImagePicker();
  File? uploadimage;

  Future<File?> compressImage(File file, BuildContext context) async {
    try {
      final dir = await getTemporaryDirectory();
      final targetPath = path.join(
        dir.path,
        '${DateTime.now().millisecondsSinceEpoch}_compressed.jpg',
      );

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 85,
        minWidth: 800,
        minHeight: 800,
        format: CompressFormat.jpeg,
      );

      return compressedFile != null ? File(compressedFile.path) : file;
    } catch (e) {
      print('Error compressing image: $e');
      state = state.copyWith(isLoading: false);
      Utils.flushBarErrorMessage("Error compressing image", context);
      return null;
    }
  }

  Future<void> pickImages(BuildContext context) async {
    try {
      final XFile? pickedFile = await pickImage.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      // Convert XFile to File
      final File file = File(pickedFile!.path);
      final compressedFile = await compressImage(file, context);

      if (compressedFile != null) {
        state = state.copyWith(adImage: compressedFile);
      }
    } catch (e) {
      print('Error picking images: $e');
      Utils.flushBarErrorMessage("Error selecting images", context);
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