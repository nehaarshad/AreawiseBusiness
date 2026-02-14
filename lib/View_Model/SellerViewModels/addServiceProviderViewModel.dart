import 'dart:convert';
import 'dart:io';
import 'package:ecommercefrontend/repositories/serviceProvidersRepository.dart';
import 'package:ecommercefrontend/repositories/serviceRepository.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/utils/dialogueBox.dart';
import '../../core/utils/notifyUtils.dart';
import '../../states/serviceProviderState.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

import '../adminViewModels/servicesViewModel.dart';

final addServiceProviderViewModelProvider = StateNotifierProvider.family<addServiceProviderViewModel, ServiceProviderState, String>((ref, id,) {
  return addServiceProviderViewModel(ref, id);
});

class addServiceProviderViewModel extends StateNotifier<ServiceProviderState> {
  final Ref ref;
  final String id;
  final ImagePicker pickImage = ImagePicker();

  addServiceProviderViewModel(this.ref, this.id) : super(ServiceProviderState()) {

  }

  final TextEditingController providerName=TextEditingController();
  final TextEditingController email=TextEditingController();
  final TextEditingController contactnumber=TextEditingController();
  final TextEditingController experience=TextEditingController();
  final TextEditingController OpenHours=TextEditingController();
  List<Map<String, TextEditingController>> serviceRows = [
    { "detail": TextEditingController(),
      "cost": TextEditingController(),
    } ];

  void addServiceRow() {
    serviceRows.add(
        { "detail": TextEditingController(),
          "cost": TextEditingController(),
        });
    state = state.copyWith();
  }

  void removeServiceRow(int index) {
    serviceRows.removeAt(index);
    state = state.copyWith();
  }

  List<Map<String, dynamic>> collectServiceDetails() {
    return serviceRows.map((row) {
      return {
        "detail": row["detail"]!.text,
        "cost":int.tryParse(row["cost"]!.text) };
    }).toList();
  }


  File? uploadimage;
  final GlobalKey key=GlobalKey();

  void toggleCustomArea(bool value) {
    state = state.copyWith(
      isCustomArea: value,
      selectedArea: value ? null : state.selectedArea,
    );
  }
  void setLocation(String? area) {
    state = state.copyWith(selectedArea: area);
  }

  bool isDisposed = false;

  @override
  void dispose() {
    isDisposed = true;
    providerName.dispose();
    email.dispose();
    uploadimage==null;
    experience.dispose();
    contactnumber.dispose();
    OpenHours.dispose();
    state.selectedArea==null;
    state=state.copyWith(image: null,isLoading: false);
    state = ServiceProviderState(isLoading: false, image: null); // Reset to initial state

    super.dispose();
  }

  void resetState() {
    providerName.clear();
    email.clear();
    experience.clear();
    contactnumber.clear();
    OpenHours.clear();
    uploadimage==null;
    state=state.copyWith(image: null,isLoading: false);
      state = ServiceProviderState(isLoading: false, image: null); // Reset to initial state


  }

  Future<void> pickImages(BuildContext context) async {
    try {
      final XFile? pickedFiles = await pickImage.pickImage(source: ImageSource.gallery);

      // Check if adding these images would exceed the limit
      if (pickedFiles != null) {
        // Show loading indicator

        state = state.copyWith(isLoading: true);
        final originalFile = File(pickedFiles.path);
        final compressedFile = await compressImage(originalFile,context);
        final newImages = compressedFile;
        uploadimage=compressedFile;
        if (compressedFile != null) {
          state = state.copyWith(image: compressedFile,isLoading: false);
        }

      }
    } catch (e) {
      print('Error picking images: $e');
      state = state.copyWith(isLoading: false);
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

  Future<bool> addServiceProvider({
    required String userid,
    required String serviceid,
    required BuildContext context,
  }) async
  {
    try {


      print("User ID: $id");
      // Validate images
      if (state.image == null || uploadimage== null) {
        Utils.flushBarErrorMessage("Please select image", context);
        return false;
      }
      final form = key.currentState as FormState?; if (form == null || !form.validate()) { return false; }
      final location = state.isCustomArea ? null : state.selectedArea;

      if (location == null ) {
        Utils.flushBarErrorMessage("Select location", context);
        return false;

      }

      state = state.copyWith(isLoading: true);

      List<Map<String,dynamic>> serviceDetails= collectServiceDetails();

      if(providerName.text.isEmpty || contactnumber.text.isEmpty|| email.text.isEmpty || experience.text.isEmpty || OpenHours.text.isEmpty)
        {
          DialogUtils.showErrorDialog(context, "Incomplete details");
          return false;
        }
      if (serviceDetails.isEmpty || serviceDetails[0].isEmpty  ){
        DialogUtils.showErrorDialog(context, "Provide your available service details");
         return false;
      }
      dynamic details=jsonEncode(serviceDetails);
      int? serviceId=int.tryParse(serviceid);
      int? number = int.tryParse(contactnumber.text.trim());
      // Prepare data for the API request
      final data = {
        'providerName': providerName.text.trim(),
        'email':email.text.trim(),
        'contactnumber': number,
        'OpenHours': OpenHours.text.trim(),
        'experience':experience.text.trim(),
        'serviceID': serviceId,
        'serviceDetails': details,
        'location':location.trim()
      };
      await ref.read(serviceProvidersDetailsProvider).addServiceProvider(userid, data, uploadimage);
      ref.invalidate(serviceViewModelProvider);
      await ref.read(serviceViewModelProvider.notifier).getServices();

      resetState();
      toggleCustomArea(false);
      setLocation(null);
   //   state = state.copyWith(isLoading: false,images: null);
      await DialogUtils.showSuccessDialog(context,"Service added");
      Navigator.pop(context);
      return true;
    } catch (e) {
      print(e);
      state = state.copyWith(
        isLoading: false,
      );
      resetState();
      await  DialogUtils.showErrorDialog(context,"Something went wrong. Try Later!");
      return false;
    }
  }

  Future<void> Cancel(BuildContext context) async{
    resetState();
    toggleCustomArea(false);
    setLocation(null);
   state=state.copyWith(image: null);
   setLocation(null);

    await Future.delayed(Duration(milliseconds: 500));
    Navigator.pop(context);
  }

}
