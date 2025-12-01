import 'package:ecommercefrontend/models/UserAddressModel.dart';
import 'package:ecommercefrontend/models/UserDetailModel.dart';
import 'package:ecommercefrontend/models/hiveModels/userHiveModel.dart';

class UserMapper {
  static UserHiveModel toHiveModel(UserDetailModel user) {
    return UserHiveModel(
      id: user.id,
      username: user.username,
      email: user.email,
      createdAt: user.createdAt,
      role: user.role,
      token: user.token,
      updatedAt: user.updatedAt,
      contactnumber: user.contactnumber,
      imageUrl:user.image?.imageUrl != null && user.image!.imageUrl!.isNotEmpty
          ? user.image!.imageUrl!
          : "https://th.bing.com/th/id/R.8e2c571ff125b3531705198a15d3103c?rik=gzhbzBpXBa%2bxMA&riu=http%3a%2f%2fpluspng.com%2fimg-png%2fuser-png-icon-big-image-png-2240.png&ehk=VeWsrun%2fvDy5QDv2Z6Xm8XnIMXyeaz2fhR3AgxlvxAc%3d&risl=&pid=ImgRaw&r=0",
      address: user.address != null
          ? AddressHiveModel(
        id: user.address?.id ?? 0,
        address: user.address?.address ?? "N/A",
        sector: user.address?.sector ?? "N/A",
        city: user.address?.city ?? "N/A",
      )
          : null,
    );
  }

  static UserDetailModel fromHiveModel(UserHiveModel? user) {
    if (user == null) {
      return UserDetailModel();
    }

    return UserDetailModel(
      id: user.id,
      username: user.username,
      email: user.email,
      role: user.role,
      token: user.token,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      contactnumber: user.contactnumber,
      image: user.imageUrl != null
          ? ProfileImage(imageUrl: user.imageUrl)
          : null,
      address: user.address != null
          ? Address(
        id: user.address!.id,
        address: user.address!.address,
        sector: user.address!.sector,
        city: user.address!.city,
      )
          : null,
    );
  }
}