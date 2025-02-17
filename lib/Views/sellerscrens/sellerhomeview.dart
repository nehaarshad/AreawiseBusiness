import 'package:ecommercefrontend/models/auth_users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../View_Model/UserProfile/UserProfileViewModel.dart';
import '../shared/widgets/DashBoardProductsView.dart';
import '../shared/widgets/logout_button.dart';

class sellerhomeview extends ConsumerStatefulWidget {
  int id;
   sellerhomeview({required this.id});

  @override
  ConsumerState<sellerhomeview> createState() => _sellerhomeviewState();
}

class _sellerhomeviewState extends ConsumerState<sellerhomeview> {


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 20),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(70.0),
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8,horizontal: 15),
                child: Text( "New Arrival",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold) ),
              ),
              Row(
                children: [
                  Text("See All",style: TextStyle(color: Colors.grey),),
                  Icon(Icons.arrow_forward_ios_sharp,size: 10,),
                ],
              ),


            ],
          ),
          Products(userid: widget.id,),
        ],
      ),
    );
  }
}
