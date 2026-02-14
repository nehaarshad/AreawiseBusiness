import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:ecommercefrontend/core/utils/dialogueBox.dart';
import 'package:ecommercefrontend/models/categoryModel.dart';
import 'package:ecommercefrontend/models/servicesModel.dart';
import 'package:ecommercefrontend/repositories/serviceRepository.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod/riverpod.dart';
import '../../core/utils/notifyUtils.dart';
import '../../core/utils/routes/routes_names.dart';
import '../../repositories/categoriesRepository.dart';
import '../../states/serviceState.dart';
import '../SharedViewModels/getAllCategories.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

import '../../states/categoryStates.dart';
import '../auth/sessionmanagementViewModel.dart';

final serviceViewModelProvider = StateNotifierProvider<serviceViewModel, ServicedState>((
    ref,
    ) {
  return serviceViewModel(ref);
});

class serviceViewModel extends StateNotifier<ServicedState> {
  final Ref ref;
  final pickimage = ImagePicker();
  serviceViewModel(this.ref) : super(ServicedState()) {
    getServices();
  }
  File? uploadimage;
  bool loading = false;

  void resetState() {
    loading=false;
    state = ServicedState(isLoading: false,image: null); // Reset to initial state
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
      state = state.copyWith(isLoading: false);
      Utils.flushBarErrorMessage("Error compressing image", context);
      return null;
    }
  }

  Future<XFile?> getImagesFromSource(ImageSource source) async {
    if (source == ImageSource.camera) {
      // Take a single picture from camera
      final XFile? image = await pickimage.pickImage(source: source);
      return image != null ? image : null;
    } else {
      // Pick multiple from gallery
      return await  pickimage.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
    }
  }

  Future<void> pickImages(BuildContext context) async {
    try {
      final source = await DialogUtils.showImageSourceDialog(context);
      if (source == null) {
        state = state.copyWith(isLoading: false);
        return;
      }

      final XFile? pickedFile = await getImagesFromSource(source);

      if (pickedFile == null) {
        Utils.flushBarErrorMessage("Upload Service Poster", context);
        return;
      }

      // Convert XFile to File
      final File file = File(pickedFile.path);
      final compressedFile = await compressImage(file, context);

      if (compressedFile != null) {
        state = state.copyWith(image: compressedFile);
      }
    } catch (e) {
      print('Error picking images: $e');
      Utils.flushBarErrorMessage("Error selecting images", context);
    }
  }

  Future<void> getServices() async {
    try {
      List<Services?> services = await ref.read(serviceProvider).getServices();

      state = state.copyWith(services:services);
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  Future<void> deleteService(String id) async {
    try {
      print('Category id sent to be deleted! ${id}');
      await ref.read(serviceProvider).deleteService(id);
      getServices();
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  bool isadmin=false;
  Future<void> addService(String name,BuildContext context) async {
    try {
      final role = ref.read(sessionProvider)?.role;
     String status= role =='Admin'?"Active":"Requested";
      final data={
        'name':name,
        'status':status
      };
      await ref.read(serviceProvider).addService(data, state.image);
       resetState();
      state = state.copyWith(isLoading: false);
      getServices();
      uploadimage=null;
      if(status=="Requested"){
       await DialogUtils.showSuccessDialog(context, "Your service has been submitted and is pending admin approval.");
      }

      Navigator.pop(context);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  final Services customServiceSelection= Services(name: "Others",imageUrl: "https://tse2.mm.bing.net/th/id/OIP.0ipNU3wUScLmk1M7tHhhxgHaHa?cb=defcache2defcache=1&rs=1&pid=ImgDetMain&o=7&rm=3");

  Widget Service(List<Services?> services,String? userid,String role) {
    isadmin=role=="Admin" ? true : false;
    List<Services?> updatedServices = [...services];
     if (role=="Seller") { updatedServices.add(customServiceSelection); }
    if(updatedServices == null ){
      return SizedBox.shrink();
    }
      if (updatedServices.isEmpty || updatedServices == null) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text("No Services Yet!"),
          ),
        );
      }
      else{
      return ListView.builder(
        itemCount: updatedServices.length ,
        itemBuilder: (context, index) {
          final service = updatedServices[index];
          if(service==null){
            return SizedBox.shrink();
          }
          print(service?.imageUrl);
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                   if(role == "Seller"){ //t
                     if(service.name == "Others"){
                       Navigator.pushNamed(
                         context,
                         routesName.addServices,
                       );
                     }
                   else {
                       final id = ref.read(sessionProvider)?.id;
                     final params={
                       "serviceId":service.id.toString(),
                       "sellerId":id.toString()
                     };
                       Navigator.pushNamed(
                         context,
                         routesName.addServiceProvider,
                         arguments: params

                       );
                     }
                   }
                   else{

                     bool isAdmin = role =="Admin" ? true :false;
                       final parameters = {
                         'Services': service,
                         'isAdmin': isAdmin,
                       };
                       Navigator.pushNamed(
                         context,
                         routesName.serviceProviders,
                         arguments: parameters,
                       );

                   }
                  },

                  leading: (service.imageUrl != null && service.imageUrl!.isNotEmpty)
                      ? CachedNetworkImage(
                    imageUrl:   service.imageUrl!,
                    fit: BoxFit.cover,
                    width: 50.w,
                    height: 40.h,
                    errorWidget: (context, error, stackTrace) {
                      return const Icon(Icons.miscellaneous_services_sharp);
                    },
                  )
                      : const Icon(Icons.image_not_supported),
                  title: Text("${service.name}",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 18.sp),),
                  subtitle:role == "Admin" ? Text("${service.status}",style: TextStyle(color: service.status == 'Active'?Appcolors.baseColor:Colors.deepOrange,fontWeight: FontWeight.w600),) :SizedBox.shrink(),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                     if(role == "Admin") IconButton(
                       onPressed: (){
                         Navigator.pushNamed(context, routesName.updateService,arguments: service.id.toString());
                       },
                       icon: Icon(Icons.edit, size: 20.h,color: Appcolors.baseColor,),),
                      if(role == "Admin") IconButton(
                        onPressed: (){
                          DeleteDialogBox(service,context);
                        },
                        icon: Icon(Icons.delete, size: 20.h,color: Colors.red,),),
                      if(role != "Admin")Icon(Icons.arrow_forward_ios_sharp, size: 12.h,color: Colors.grey,),
                    ],
                  ),
                ),
              ],
            ),
          );

        },
      );
    }
  }


  void DeleteDialogBox(Services service,BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title:  Text(
          'Delete Service',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${service.name}"? ',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          TextButton(
            onPressed: () async {
              await ref.read(serviceViewModelProvider.notifier)
                  .deleteService(service.id.toString());
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }


}
