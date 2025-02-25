import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../shared/widgets/DashBoardProductsView.dart';

//get userId
class buyerhomeview extends ConsumerStatefulWidget {
  int id;
  buyerhomeview({required this.id});

  @override
  ConsumerState<buyerhomeview> createState() => _buyerhomeviewState();
}

class _buyerhomeviewState extends ConsumerState<buyerhomeview> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
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
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                child: Text(
                  "New Arrival",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: [
                  Text("See All", style: TextStyle(color: Colors.grey)),
                  Icon(Icons.arrow_forward_ios_sharp, size: 10),
                ],
              ),
            ],
          ),
          AllProducts(userid: widget.id),
        ],
      ),
    );
  }
}
