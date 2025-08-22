import 'package:ecommercefrontend/Views/admin_screens/searchUserView.dart';
import 'package:ecommercefrontend/core/utils/routes/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../View_Model/adminViewModels/UserViewModel.dart';
import '../../core/utils/colors.dart';
import 'Widgets/searchUser.dart';

class UserView extends ConsumerStatefulWidget {
  const UserView({super.key});

  @override
  ConsumerState<UserView> createState() => _UsersViewState();
}

class _UsersViewState extends ConsumerState<UserView> {


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(UserViewModelProvider.notifier).getallusers();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reset user list when coming back to this view
    Future.microtask(() async{
     await ref.read(UserViewModelProvider.notifier).getallusers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.whiteSmoke,
      body: ListView(
        children: [
          SizedBox(height: 8.h,),
          searchUser(),
          Padding(
            padding:  EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: (){
                  Navigator.pushNamed(context, routesName.addUser);
                }, child: Text(" + Add User"))
              ],
            ),
          ),
          SizedBox(height: 15.h,),
         Consumer(
                  builder: (context, ref, child) {
                    final userState = ref.watch(UserViewModelProvider);
                    return userState.when(
                      loading:
                          () => const Center(
                            child: CircularProgressIndicator(color: Appcolors.baseColor),
                          ),
                      data: (users) {
                        if (users.isEmpty) {
                          return Center(child: Text("No User available."));
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final user = users[index];
                            return  InkWell(
                                onTap: () {},
                                child: Column(
                                  children: [
                                    ListTile(
                                      onTap: () {
                                        final parameters={
                                          'id':user.id,
                                          'role':user.role
                                        };
                                        Navigator.pushNamed(
                                          context,
                                          routesName.profile,
                                          arguments:parameters,
                                        );
                                      },
                                      leading: Image.network(
                                        user!.image?.imageUrl?.isEmpty == false
                                            ? user.image!.imageUrl!
                                            : "https://th.bing.com/th/id/R.8e2c571ff125b3531705198a15d3103c?rik=gzhbzBpXBa%2bxMA&riu=http%3a%2f%2fpluspng.com%2fimg-png%2fuser-png-icon-big-image-png-2240.png&ehk=VeWsrun%2fvDy5QDv2Z6Xm8XnIMXyeaz2fhR3AgxlvxAc%3d&risl=&pid=ImgRaw&r=0",
                                        width: 56.w,
                                        height: 60.h,
                                        fit: BoxFit.cover,
                                      ),
                                      title: Text("${user.username}",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16.sp),),
                                      subtitle: Text("${user.role}",style:  TextStyle(fontWeight: FontWeight.w300,fontSize: 14.sp)),
                                      trailing: Row(
                                       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          user.role=="Admin"
                                              ?
                                          SizedBox.shrink()
                                              :
                                          IconButton(
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                context,
                                                routesName.sShop,
                                                arguments: user.id,//send userId
                                              ); },
                                            icon: Icon(Icons.store, size: 20.h,color: Colors.blue,),),
                                          IconButton(
                                              onPressed: () async{
                                                       await ref.read(UserViewModelProvider.notifier).deleteusers(user.id.toString(),context);
                                              },
                                              icon: Icon(Icons.delete, size: 25.h,color: Colors.red,),),
                                          Icon(Icons.arrow_forward_ios_sharp, size: 8.h,color: Colors.grey,),
                                        ],
                                      ),
                                    ),

                                    Divider()
                                  ],
                                ),
                              );

                          },
                        );
                      },
                      error: (err, stack) => Center(child: Text('Error: $err')),
                    );
                  },
                ),


        ],
      ),
    );
  }
}
