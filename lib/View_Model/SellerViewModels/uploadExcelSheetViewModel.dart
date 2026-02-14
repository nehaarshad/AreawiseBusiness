import 'dart:io';
import 'package:ecommercefrontend/View_Model/SellerViewModels/addProductViewModel.dart';
import 'package:ecommercefrontend/View_Model/SellerViewModels/createFeatureProductViewModel.dart';
import 'package:ecommercefrontend/models/ProductModel.dart';
import 'package:ecommercefrontend/models/SubCategoryModel.dart';
import 'package:ecommercefrontend/models/categoryModel.dart';
import 'package:ecommercefrontend/models/shopModel.dart';
import 'package:ecommercefrontend/repositories/categoriesRepository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/utils/dialogueBox.dart';
import '../../core/utils/notifyUtils.dart';
import '../../repositories/ShopRepositories.dart';
import '../../repositories/product_repositories.dart';
import '../SharedViewModels/getAllCategories.dart';
import '../SharedViewModels/productViewModels.dart';
import '../../states/ProductStates.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

final uploadExcelSheetProvider = StateNotifierProvider.family<uploadProductsExcelSheetViewModel, ProductState,String>((ref,id ) {
  return uploadProductsExcelSheetViewModel(ref,id);
});

class uploadProductsExcelSheetViewModel extends StateNotifier<ProductState> {
  final Ref ref;
  final String userid;
   uploadProductsExcelSheetViewModel(this.ref,this.userid) : super(ProductState()) {

  }

  bool isDisposed = false;
  File? originalFile;
  @override


  Future<void> pickFile(BuildContext context) async {
    try {
      state = ProductState(isLoading: false, uploadedFile: null); // Reset to initial state

      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['xls', 'xlsx']
      );
      if (result != null) {
         originalFile = File(result.files.single.path!);
        PlatformFile file = result.files.first;
        String filename= "${file.name}";

        state = state.copyWith(uploadedFile: filename);
      }



    } catch (e) {
      print('Error picking images: $e');
    }
  }

  void resetState() {
    if (!isDisposed) {
      state = ProductState(isLoading: false, uploadedFile: null); // Reset to initial state

    }
  }


  Future<bool> uploadProduct({
    required BuildContext context,
  }) async
  {
    try {

      // Validate images
      if (state.uploadedFile != null && state.uploadedFile!.isEmpty ) {
        await DialogUtils.showSuccessDialog(context,"No file chosen. Upload an Excel sheet to continue.");
        return false;
      }

      //fetch shopId
      ShopModel? shop= ref.watch(addProductProvider(userid)).selectedShop;
      final shopId = shop==null ? null : shop.id.toString();
      print("selected shop ${shop?.shopname}");
      if(shopId == null){
        Utils.flushBarErrorMessage("Select your Active Shop", context);
        return false;
      }
      state = state.copyWith(isLoading: true);

     // ProductModel product=await ref.read(productProvider).addProductViaFile( shopId, originalFile);
      //print("Api Response ${product}");

      state = state.copyWith(isLoading: false,uploadedFile: null);
      await DialogUtils.showSuccessDialog(context,"File uploaded successfully. Processing your products…");
      return true;
    } catch (e) {
      print(e);
      state = state.copyWith(
        isLoading: false,
      );
      await  DialogUtils.showErrorDialog(context,"Failed to upload File. Try Later…");
      return false;
    }
  }

  Future<void> Cancel(String userId,BuildContext context) async{
    await Future.delayed(Duration(milliseconds: 500));
    Navigator.pop(context);
  }

}
