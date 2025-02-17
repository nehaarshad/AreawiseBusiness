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
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("All Users"))),
      body: Consumer(
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
                    child: InkWell(
                      onTap: () {},
                      child: ListTile(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            routesName.profile,
                            arguments: user.id,
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
                        title: Text("${user.username}"),
                        subtitle: Text("${user.role}"),
                        trailing: Icon(Icons.arrow_forward_ios_sharp, size: 15),
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
