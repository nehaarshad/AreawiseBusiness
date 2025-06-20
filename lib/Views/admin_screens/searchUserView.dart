import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../View_Model/adminViewModels/UserViewModel.dart';
import '../../core/utils/routes/routes_names.dart';

class searchUserView extends ConsumerStatefulWidget {
  final String search;
  const searchUserView({super.key, required this.search});

  @override
  ConsumerState<searchUserView> createState() => _SearchUserViewState();
}

class _SearchUserViewState extends ConsumerState<searchUserView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(UserViewModelProvider.notifier).searchuser(widget.search);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.whiteColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            await ref.read(UserViewModelProvider.notifier).getallusers();
            if (mounted) Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final userState = ref.watch(UserViewModelProvider);
          return userState.when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: Appcolors.blueColor),
            ),
            data: (users) {
              if (users.isEmpty) {
                return const Center(child: Text("No users found"));
              }
              return ListView.builder(
                itemCount: users.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final user = users[index];
                  if (user == null) return const SizedBox();

                  return Card(
                    color: Appcolors.whiteColor,
                    child: InkWell(
                      onTap: () {},
                      child: Column(
                          children: [
                          ListTile(
                          onTap: () {
                    final parameters = {
                    'id': user.id,
                    'role': user.role
                    };
                    Navigator.pushNamed(
                    context,
                    routesName.profile,
                    arguments: parameters,
                    );
                    },
                      leading: Image.network(
                        user.image?.imageUrl?.isNotEmpty == true
                            ? user.image!.imageUrl!
                            : "https://via.placeholder.com/56",
                        width: 56.w,
                        height: 60.h,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        user.username ?? 'No username',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18.sp,
                        ),
                      ),
                      subtitle: Text(
                        user.role ?? 'No role',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 14.sp,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () async {
                              await ref
                                  .read(UserViewModelProvider.notifier)
                                  .deleteusers(user.id.toString());
                            },
                            icon: Icon(
                              Icons.delete,
                              size: 25.h,
                              color: Colors.red,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_sharp,
                            size: 14.h,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            routesName.sShop,
                            arguments: user.id,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Appcolors.blueColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0.r),
                          )),
                          child: Text(
                            "User Shops",
                            style: TextStyle(
                              color: Appcolors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
                            ),
                          ),
                        ),
                      )
                                          ],
                    ),
                  ),
                  );
                },
              );
            },
            error: (err, stack) => Center(child: Text('Error: $err')),
          );
        },
      ),
    );
  }
}