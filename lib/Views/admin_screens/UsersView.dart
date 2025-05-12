import 'package:ecommercefrontend/core/utils/routes/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../View_Model/adminViewModels/UserViewModel.dart';
import '../shared/widgets/colors.dart';

class UserView extends ConsumerStatefulWidget {
  const UserView({super.key});

  @override
  ConsumerState<UserView> createState() => _UsersViewState();
}

class _UsersViewState extends ConsumerState<UserView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 100,),
              Text("All Users",style:  TextStyle(fontWeight: FontWeight.w600,fontSize: 18)),
              SizedBox(width: 50,),
              TextButton(onPressed: (){
                Navigator.pushNamed(context, routesName.addUser);
              }, child: Text(" + Add User"))
            ],
          ),
        ),
        SizedBox(height: 10,),
        Expanded(
          child: Consumer(
              builder: (context, ref, child) {
                final userState = ref.watch(UserViewModelProvider);
                return userState.when(
                  loading:
                      () => const Center(
                        child: CircularProgressIndicator(color: Appcolors.blueColor),
                      ),
                  data: (users) {
                    if (users.isEmpty) {
                      return Center(child: Text("No User available."));
                    }
                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return Card(
                          color: Appcolors.whiteColor,
                          child: InkWell(
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
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                  title: Text("${user.username}",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),),
                                  subtitle: Text("${user.role}",style:  TextStyle(fontWeight: FontWeight.w300,fontSize: 14)),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                          onPressed: () async{
                                                   await ref.read(UserViewModelProvider.notifier).deleteusers(user.id.toString());
                                          },
                                          icon: Icon(Icons.delete, size: 25,color: Colors.red,),),
                                      Icon(Icons.arrow_forward_ios_sharp, size: 14,color: Colors.grey,),
                                    ],
                                  ),
                                ),
                                Divider(),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(100, 0, 100, 10),
                                      child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                              context,
                                              routesName.sShop,
                                              arguments: user.id,//send userId
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Appcolors.blueColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(40.0),
                                            ),
                                          ),
                                          child: const Text(
                                            "User Shops",
                                            style: TextStyle(
                                              color: Appcolors.whiteColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),

                                    ),
                                  ],
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
        ),
      ],
    );
  }
}
