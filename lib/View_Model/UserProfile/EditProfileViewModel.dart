import 'dart:async';
import 'dart:io';
import 'package:ecommercefrontend/repositories/UserDetailsRepositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/utils/utils.dart';
import '../../models/UserDetailModel.dart';
import 'package:flutter/material.dart';

final editProfileViewModelProvider=StateNotifierProvider.family<EditProfileViewModel,AsyncValue<UserDetailModel?>,String>((ref,id){
  return EditProfileViewModel(ref,id);
});

class EditProfileViewModel extends StateNotifier<AsyncValue<UserDetailModel?>>{
  final Ref ref;
  String id;
  EditProfileViewModel(this.ref,this.id):super(AsyncValue.loading()){
  initValues(id);
  }

  final key=GlobalKey<FormState>();
  late TextEditingController username;
  late TextEditingController email;
  late TextEditingController contactnumber;
  late TextEditingController password;
  late TextEditingController role;
  late TextEditingController sector;
  late TextEditingController city;
  late TextEditingController address;
  File? uploadimage;
  final pickimage = ImagePicker();
  bool loading= false;

  void initValues(String id) async{
    try{
    UserDetailModel  userdata = await ref.read(userProvider).getuserbyid(id);
    username=TextEditingController(text: userdata.username );
    email=TextEditingController(text: userdata.email);
    contactnumber=TextEditingController(text: userdata.contactnumber.toString());
    role=TextEditingController(text:userdata.role );
    sector=TextEditingController(text: userdata.address?.sector ?? "N/A");
    city=TextEditingController(text: userdata.address?.city ?? "N/A");
    address=TextEditingController(text: userdata.address?.address ?? "N/A");
    state=AsyncValue.data(userdata);
  }catch(e){
      state=AsyncValue.error(e, StackTrace.current);
    }
  }

  void dispose() {
    username.dispose();
    email.dispose();
    contactnumber.dispose();
    role.dispose();
    sector.dispose();
    city.dispose();
    address.dispose();
  }

  Future<void> pickImages() async {
    final XFile? pickedimage = await pickimage.pickImage(source: ImageSource.gallery,imageQuality: 80);

    if (pickedimage != null) {
      uploadimage=File(pickedimage.path);
      state = AsyncValue.data(state.value?.copyWith(image: ProfileImage(imageUrl: pickedimage.path)));
    }
  }

  Future<void> updateUser(Map<String,dynamic> data, File? image,BuildContext context)async{
  try{
    final response=await ref.read(userProvider).updateUser(data, id, image);
    final updatedUser = UserDetailModel.fromJson(response);
    state=AsyncValue.data(updatedUser);
    Utils.toastMessage("User Updated Successfully!");
    Navigator.pop(context);
  }catch(e){
    state=AsyncValue.error(e, StackTrace.current);
  }
  }

}
