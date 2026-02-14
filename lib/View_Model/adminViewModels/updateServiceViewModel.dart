import 'dart:async';
import 'dart:io';
import 'package:ecommercefrontend/View_Model/adminViewModels/servicesViewModel.dart';
import 'package:ecommercefrontend/models/servicesModel.dart';
import 'package:ecommercefrontend/repositories/UserDetailsRepositories.dart';
import 'package:ecommercefrontend/repositories/serviceRepository.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/utils/dialogueBox.dart';
import '../../core/utils/notifyUtils.dart';
import '../../core/utils/routes/routes_names.dart';
import '../../models/UserDetailModel.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import '../adminViewModels/UserViewModel.dart';
import '../adminViewModels/searchUserViewModel.dart';
import '../auth/sessionmanagementViewModel.dart';

final updateServiceViewModelProvider = StateNotifierProvider.family<updateServiceViewModel, AsyncValue<Services?>, String>((ref, id) {
  return updateServiceViewModel(ref, id);
});

class updateServiceViewModel extends StateNotifier<AsyncValue<Services?>> {
  final Ref ref;
  String id;
  updateServiceViewModel(this.ref, this.id) : super(AsyncValue.loading()) {
    initValues(id);
  }


  final key = GlobalKey<FormState>();
  late TextEditingController name;
  late String? status;
  File? uploadimage;
  final pickimage = ImagePicker();
  bool loading = false;

  void initValues(String id) async {
    try {

      Services? service = await ref.read(serviceProvider).findService(id);
      name = TextEditingController(text: service?.name ?? '');
      status = service?.status ?? '';
      state = AsyncValue.data(service);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Widget serviceImage(Services service,BuildContext context) {
    return Column(
      children: [
        GestureDetector(
        onTap: () {
      pickImages(context);
    },
    child: Container(
    height: 200.h,
    decoration: BoxDecoration(
    color: Colors.grey[200],
    border: Border.all(color: Colors.grey),
    borderRadius: BorderRadius.circular(8.0.r),
    ),
    child: uploadimage != null
    ? Image.file(
    uploadimage!,
    fit: BoxFit.cover,
    )
        : service.imageUrl != null && service.imageUrl!.isNotEmpty
    ? Image.network(
    service.imageUrl!,
    fit: BoxFit.cover,
    )
        : Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Icon(Icons.upload, size: 50.h, color: Colors.grey[600]),
    SizedBox(height: 8),
    Text(
    "Tap to upload image",
    style: TextStyle(color: Colors.grey[600]),
    ),
    ],
    ),
    ),
    ),
    ],
    );
  }


  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }

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
      Utils.flushBarErrorMessage("Error compressing image", context);
      return null;
    }
  }

  Future<void> pickImages(BuildContext context) async {
    try {
      final XFile? pickedFile = await pickimage.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile == null) {
        Utils.flushBarErrorMessage("Upload Ad Poster", context);
        return;
      }

      // Convert XFile to File
      final File file = File(pickedFile.path);
      final compressedFile = await compressImage(file, context);

      if (compressedFile != null) {
        uploadimage = File(compressedFile.path);
        state = AsyncValue.data(
          state.value?.copywith(image:  compressedFile),
        );  }
    } catch (e) {
      print('Error picking images: $e');

    }
  }

  Future<void> updateService(
      BuildContext context,
      ) async {
    try {
      final data={
        'name':name.text.trim(),
        'status':status ?? 'Active'
      };
      print(data['name']);
      final response = await ref.read(serviceProvider).updateService( id,data, state.value!.image);

      await DialogUtils.showSuccessDialog(context,"Service updated");
      ref.invalidate(serviceViewModelProvider);
      await ref.read(serviceViewModelProvider.notifier).getServices();
      await Future.delayed(Duration(seconds: 1));
      Navigator.pop(context);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateServiceStatus(
      Map<String, dynamic> data,
      File? image,
      BuildContext context,
      ) async {
    try {
      final response = await ref.read(serviceProvider).updateServiceStatus( id,data);
      state = AsyncValue.data(response);
      await DialogUtils.showSuccessDialog(context,"Service updated");
      await ref.read(serviceViewModelProvider.notifier).getServices();
      await Future.delayed(Duration(seconds: 1));
      Navigator.pop(context);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
