import 'dart:io';
import 'package:ecommercefrontend/View_Model/SellerViewModels/ShopStates.dart';
import 'package:flutter/material.dart';
import 'package:ecommercefrontend/models/categoryModel.dart';
import 'package:ecommercefrontend/repositories/ShopRepositories.dart';
import 'package:ecommercefrontend/repositories/categoriesRepository.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/utils/dialogueBox.dart';
import '../../core/utils/notifyUtils.dart';
import '../SharedViewModels/getAllCategories.dart';
import '../adminViewModels/ShopViewModel.dart';
import 'sellerShopViewModel.dart';
import 'package:path/path.dart' as path;

final addShopProvider = StateNotifierProvider.family<AddShopViewModel, ShopState, String>((ref, id,) {
      return AddShopViewModel(ref, id);
    });

class AddShopViewModel extends StateNotifier<ShopState> {
  final Ref ref;
  final String shopId;
  final ImagePicker pickImage = ImagePicker();

  AddShopViewModel(this.ref, this.shopId) : super(ShopState()) {
    getCategories();
  }

  bool isDisposed = false;

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }

  Future<void> getCategories() async {
    try {
      if (isDisposed) return;
      state = state.copyWith(isLoading: true);
      final categories = await ref.read(categoryProvider).getCategories();
      if (isDisposed) return;
      state = state.copyWith(categories: categories, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      print('Error loading categories: $e');
    }
  }

  Future<void> pickImages(BuildContext context) async {
    try {
      state = state.copyWith(isLoading: true); // Show loading while processing
      final List<XFile> pickedFiles = await pickImage.pickMultiImage();
      if (pickedFiles.isNotEmpty && state.images.length + pickedFiles.length <= 5) {
        final List<File> compressedImages = [];

        // Compress each selected image
        for (final xFile in pickedFiles) {
          final originalFile = File(xFile.path);
          final compressedFile = await compressImage(originalFile,context);

          if (compressedFile != null) {
            compressedImages.add(compressedFile);
            print('Compressed image: ${originalFile.lengthSync()} -> ${compressedFile.lengthSync()} bytes');
          }
        }

        final newImages = [...state.images, ...compressedImages];
        state = state.copyWith(images: newImages, isLoading: false);
      }
    } catch (e) {
      print('Error picking images: $e');
    }
  }

  // Compress image before adding to state
  Future<File?> compressImage(File file,BuildContext context) async {
    try {
      final dir = await getTemporaryDirectory();
      final targetPath = path.join(
        dir.path,
        '${DateTime.now().millisecondsSinceEpoch}_compressed.jpg',
      );

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 85, // Match backend optimization
        minWidth: 800,
        minHeight: 800,
        format: CompressFormat.jpeg,
      );

      return compressedFile != null ? File(compressedFile.path) : file;
    } catch (e) {
      print('Error picking images: $e');
      state = state.copyWith(isLoading: false);
      Utils.flushBarErrorMessage("Error selecting images", context);
    }
  }

  void removeImage(int index) {
    final newImages = List<File>.from(state.images)
      ..removeAt(index); //[..] Cascade or Chaining Opertor in list
    state = state.copyWith(images: newImages);
  }

  void setCategory(Category? category) {
    state = state.copyWith(selectedCategory: category);
  }

  void toggleCustomCategory(bool value) {
    state = state.copyWith(
      isCustomCategory: value, //new category (true)
      selectedCategory: value ? null : state.selectedCategory, //null -> previously selected predefined category
      //null to initialize its value in other function
    );
  }

  void resetState() {
    if (!isDisposed) {
      state = ShopState(images: [], selectedCategory: null);
      getCategories();
    }
  }


  Future<void> Cancel(String userId,BuildContext context) async{
    resetState();
    ref.invalidate(sellerShopViewModelProvider(userId.toString()));
    ref.invalidate(GetallcategoriesProvider);
    await ref.read(sellerShopViewModelProvider(userId.toString()).notifier).getShops(userId.toString());
    await ref.read(GetallcategoriesProvider.notifier);
    await Future.delayed(Duration(milliseconds: 500));
    Navigator.pop(context);
  }


  Future<bool> addShop({
    required String shopname,
    required String shopaddress,
    required String sector,
    required String city,
    required String deliveryPrice,
    required int userId,
    required BuildContext context
  }) async
  {
    try {

      if (state.images.isEmpty || state.images.length > 4) {
        throw Exception('Please select 1 to 4 images');
      }

      final parsedPrice = int.tryParse(deliveryPrice);

      final categoryName =
          state.isCustomCategory
              ? null
              : state.selectedCategory?.name;
      if (categoryName == null ) {
        Utils.flushBarErrorMessage("Select Existed category ", context);
        return false;

      }

      state = state.copyWith(isLoading: true);

      final data = {
        'shopname': shopname,
        'shopaddress': shopaddress,
        'sector': sector,
        'city': city,
        'deliveryPrice':parsedPrice,
        'name': categoryName.trim(),
      };
        print('data ${data}');
      final response = await ref.read(shopProvider).addShop(data, shopId, state.images.whereType<File>().toList());
print(response);
if(response.toString()!="A payment account is required to receive online transactions. Please add one to continue."){
     await DialogUtils.showSuccessDialog(context,response.toString());

}
else{
  await DialogUtils.showErrorDialog(context,response.toString());

}
      ref.invalidate(sellerShopViewModelProvider(userId.toString()));
      await ref.read(sellerShopViewModelProvider(userId.toString()).notifier).getShops(userId.toString());///update seller shop list
      await ref.read(shopViewModelProvider.notifier).getShops();
      resetState();

     return true;


    } catch (e) {
      state = state.copyWith(
        isLoading: false,
      );
     await DialogUtils.showErrorDialog(context,"Failed to add new shop. Try Later!");
      return false;
    }
  }
}
