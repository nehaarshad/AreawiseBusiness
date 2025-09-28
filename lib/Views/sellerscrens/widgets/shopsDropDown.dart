import 'package:ecommercefrontend/View_Model/SellerViewModels/addProductViewModel.dart';
import 'package:ecommercefrontend/models/shopModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ActiveUserShopDropdown extends ConsumerStatefulWidget {
  final String userid;

  ActiveUserShopDropdown({required this.userid, Key? key}) : super(key: key);

  @override
  ConsumerState<ActiveUserShopDropdown> createState() => _ActiveUserShopState();
}

class _ActiveUserShopState extends ConsumerState<ActiveUserShopDropdown> {
  final TextEditingController shops = TextEditingController();
  final FocusNode focus = FocusNode();
  List<ShopModel> ActiveShopList = [];
  bool shopExist = false;
  bool showDropdown = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Move the logic that depends on inherited widgets to didChangeDependencies
    shops.addListener(RecommendedCategories);
  }

  @override
  void dispose() {
    shops.dispose();
    focus.dispose();
    super.dispose();
  }

  void RecommendedCategories() {
    final input = shops.text.trim().toLowerCase();
    final userShop = ref.read(addProductProvider(widget.userid.toString())).shops;

    if (input.isEmpty) {
      setState(() {
        ActiveShopList = [];
        shopExist = false;
        showDropdown = false;
      });
      return;
    }

    setState(() {

      ActiveShopList = userShop
          .where((shop) => shop.shopname!.toLowerCase().contains(input))
          .toList();
      shopExist = ActiveShopList.isEmpty;
      showDropdown = true;
    });

    if (shopExist) {
      ref.read(addProductProvider(widget.userid).notifier).toggleCustomShop(true);
    } else {
      ref.read(addProductProvider(widget.userid).notifier).toggleCustomShop(false);
    }
  }

  void _onShopSelected(ShopModel shop) {
    setState(() {
      shops.text = shop.shopname!;
      showDropdown = false;
      shopExist = false;
      ActiveShopList = [];  // Clear the suggestions
    });
    ref.read(addProductProvider(widget.userid).notifier).toggleCustomShop(false);
    ref.read(addProductProvider(widget.userid).notifier).setShop(shop);
    focus.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: shops,
          focusNode: focus,
          decoration: InputDecoration(
            labelText: 'Shop',
            hintText: 'Select Shop',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0.r),
            ),
            suffixIcon: shops.text.isNotEmpty
                ? IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  shops.clear();
                  showDropdown = false;
                  ActiveShopList = [];
                });
                ref.read(addProductProvider(widget.userid).notifier).setShop(null);
              },
            ): null,
          ),
          onChanged: (value) {
            ref.read(addProductProvider(widget.userid).notifier).setShop(null); // Reset category while typing
            RecommendedCategories();
          },
          onTap: () {
            setState(() {
              // Only show dropdown if there are categories to show
              showDropdown = ActiveShopList.isNotEmpty;
            });
          },
        ),

        if (showDropdown && ActiveShopList.isNotEmpty)
          SingleChildScrollView(
            child: Container(
              height: 200.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Scrollbar(
                thumbVisibility: true, // Always show scrollbar
                thickness: 6.0, // Scrollbar thickness
                radius: Radius.circular(3),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: ActiveShopList.length,
                  itemBuilder: (context, index) {
                    final shop = ActiveShopList[index];
                    if(shop.status != "Active"){
                      return SizedBox.shrink();
                    }
                    return ListTile(
                      title: Text(shop.shopname!),
                      onTap: () => _onShopSelected(shop),
                    );
                  },
                ),
              ),
            ),
          ),

        if (shopExist && shops.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'No Shop exist!',
              style: TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
}
