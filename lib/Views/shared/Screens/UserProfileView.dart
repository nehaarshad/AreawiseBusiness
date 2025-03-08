import 'package:ecommercefrontend/Views/shared/widgets/logout_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../View_Model/UserProfile/UserProfileViewModel.dart';
import '../../../core/utils/routes/routes_names.dart';
import '../../../models/UserAddressModel.dart';
import '../../../models/UserDetailModel.dart';
import '../widgets/colors.dart';
import '../widgets/infoRow.dart';
import '../widgets/profileImageWidget.dart';

class profileDetailView extends ConsumerStatefulWidget {
  int id;
  profileDetailView({required this.id});

  @override
  ConsumerState<profileDetailView> createState() => _profileDetailViewState();
}

class _profileDetailViewState extends ConsumerState<profileDetailView> {
  @override
  Widget build(BuildContext context) {
    final userdetail = ref.watch(
      UserProfileViewModelProvider(widget.id.toString()),
    ); //get user detail from model
    return Scaffold(
      appBar: AppBar(

      ),
      body: userdetail.when(
        loading:
            () => Center(
              child: CircularProgressIndicator(color: Appcolors.blackColor),
            ),
        data: (user) {
          if (user == null) return const Center(child: Text("User not found"));
          return Padding(
            padding: const EdgeInsets.all(28.0),
            child: Center(
              child: Column(
                children: [
                  ProfileImageWidget(user: user, height: 150, weidth: 150),
                  SizedBox(height: 20),
                  userInfo(user: user),
                  SizedBox(height: 10),
                  Divider(),
                  SizedBox(height: 10),
                  Expanded(child: addressInfo(address: user.address)),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          routesName.editprofile,
                          arguments: widget.id,
                        );
                      },
                      child: Text(
                        "Edit Profile",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class userInfo extends StatelessWidget {
  final UserDetailModel user;

  const userInfo({required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        infoWidget(heading: "Username", value: user.username ?? 'No username'),
        infoWidget(heading: "Username", value: user.email ?? 'No email'),
        infoWidget(heading: "Role", value: user.role ?? 'No role'),
        infoWidget(
          heading: "Contact",
          value: user.contactnumber?.toString() ?? 'No number',
        ),
      ],
    );
  }
}

//where user address details shows
class addressInfo extends StatelessWidget {
  final Address? address;

  const addressInfo({this.address});

  @override
  Widget build(BuildContext context) {
    if (address == null) {
      return const Text('No address information');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Address Information',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        infoWidget(heading: "Sector", value: address?.sector ?? 'N/A'),
        infoWidget(heading: "City", value: address?.city ?? 'N/A'),
        infoWidget(heading: "Address", value: address?.address ?? 'N/A'),
      ],
    );
  }
}
