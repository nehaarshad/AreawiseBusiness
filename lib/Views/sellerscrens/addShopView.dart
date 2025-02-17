import 'dart:io';
import 'package:ecommercefrontend/View_Model/SellerViewModels/addShopViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../core/utils/utils.dart';
import '../shared/widgets/ShopCategoryDropDownMenu.dart';
import '../shared/widgets/colors.dart';

class addShopView extends ConsumerStatefulWidget {
  int id;
  addShopView({required this.id});

  @override
  ConsumerState<addShopView> createState() => _addShopViewState();
}

class _addShopViewState extends ConsumerState<addShopView> {

  final formkey=GlobalKey<FormState>();
  final TextEditingController shopname=TextEditingController();
  final TextEditingController shopaddress=TextEditingController();
  final TextEditingController sector=TextEditingController();
  final TextEditingController city=TextEditingController();

  // Future getImage()async{
  //   final XFile? pickedImage=await pickimage.pickImage(source: ImageSource.gallery);
  //   if(pickedImage!=null){
  //     setState(() {
  //       uploadimage=File(pickedImage.path);
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final state=ref.watch(addShopProvider(widget.id.toString()));
    return Scaffold(
          appBar: AppBar(
            title: Text("Add Shop"),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Form(
                key: formkey,
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    if (state.images.isNotEmpty)...[
                      if(state.images.length>4)
                        Utils.flushBarErrorMessage("Select only 4 images", context),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.images.length,

                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.file(state.images[index]),
                              ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: IconButton(
                                    icon: Icon(Icons.remove_circle, color: Colors.red),
                                    onPressed: () {
                                      ref.read(addShopProvider(widget.id.toString()).notifier).removeImage(index);
                                    },
                                  ),
                                ),
                              ]
                            );
                          },
                        ),
                      ),],
                    ElevatedButton(
                        onPressed: (){ref.read(addShopProvider(widget.id.toString()).notifier).pickImages(context);},
                        child:Text("Upload Images")
                    ),
                    TextFormField(
                      controller: shopname,
                      decoration: InputDecoration(labelText: "Shop Name"),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a Shop name";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: shopaddress,
                      decoration: InputDecoration(labelText: "Shop Address"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter address";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: sector,
                      decoration: InputDecoration(labelText: "Sector"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter Sector";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: city,
                      decoration: InputDecoration(labelText: "city"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter city";
                        }
                        return null;
                      },
                    ),
                    ShopcategoryDropdown(userid: widget.id.toString()),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: state.isLoading ? null :() async {
                        if (formkey.currentState!.validate()) {
                          await ref.read(addShopProvider(widget.id.toString()).notifier).
                          addShop(shopname: shopname.text, shopaddress: shopaddress.text, sector: sector.text, city:city.text);
                        }
                      },
                      child: state.isLoading  ?  Center(child: CircularProgressIndicator(color: Appcolors.blueColor,),) : const Text('Add Shop'),
                    ),

                  ],
                ),
              ),
            ),
          )

      );
  }
}

