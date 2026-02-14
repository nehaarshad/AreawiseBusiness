import 'package:ecommercefrontend/View_Model/SellerViewModels/addServiceProviderViewModel.dart';
import 'package:ecommercefrontend/models/serviceProviderModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../View_Model/SellerViewModels/updateServiceProviderDetailsViewModel.dart';


class setAreaDropDown extends ConsumerStatefulWidget {
  final String userid;

  setAreaDropDown({required this.userid, Key? key}) : super(key: key);

  @override
  ConsumerState<setAreaDropDown> createState() => _setShopAreaDropDown();
}

class _setShopAreaDropDown extends ConsumerState<setAreaDropDown> {
  final TextEditingController shopArea = TextEditingController();
  final FocusNode focus = FocusNode();
  List<String> allAreas = [
    "PWD",
    "DHA Phase I", 'DHA Phase II', 'DHA Phase III', 'DHA PHASE IV', 'DHA Phase V', 'DHA Valley',
    "Bahria Phase 1", "Bahria Phase 2", "Bahria Phase 3", "Bahria Phase 4",
    "Bahria Phase 5", "Bahria Phase 6", "Bahria Phase 7", "Bahria Phase 8",
    "Gulberg Green",
    'Park View City',
    'Golra Morr',
    '6th Road',
    'Murree Road',
    "Soan Garden",
    'Khana Pul',
    "Blue Area",
    "Jinnah Garden,Phase-1", "Jinnah Garden,Phase-2",
    'A-17', 'B-17', 'B-18',
    'D-11', 'D-12', 'D-13', 'D-14', 'D-15', 'D-16', 'D-17',
    'E-7', 'E-8', 'E-9', 'E-10', 'E-11', 'E-12', 'E-13', 'E-14', 'E-15', 'E-16', 'E-17', 'E-18',
    "I-8", "I-9", "I-10", 'I-11', 'I-12', "I-13", 'I-14', 'I-15', 'I-16', 'I-17', '1-18',
    'H-8', 'H-9', 'H-10', 'H-11', 'H-12', 'H-13', 'H-14', 'H-15', 'H-16', 'H-17',
    'G-5', 'G-6', 'G-7', 'G-8', 'G-9', 'G-10', 'G-11', 'G-12', 'G-13', 'G-14', 'G-15', 'G-16', 'G-17',
    'F-5', 'F-6', 'F-7', 'F-8', 'F-9', 'F-10', 'F-11', 'F-12', 'F-13', 'F-14', 'F-15', 'F-16', 'F-17',
    'AGOCHS, Phase-I', 'AGOCHS, Phase-II'
  ];
  bool addnewArea = false;
  bool showDropdown = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    shopArea.addListener(RecommendedArea);
  }

  @override
  void dispose() {
    shopArea.dispose();
    focus.dispose();
    super.dispose();
  }

  void RecommendedArea() {
    final input = shopArea.text.trim().toLowerCase();
    addnewArea = false;
    showDropdown = true;


    setState(() {
      allAreas = allAreas
          .where((area) => area.toLowerCase().contains(input))
          .toList();
      addnewArea = allAreas.isEmpty;
      showDropdown = true;
    });

    if (addnewArea) {
      ref.read(addServiceProviderViewModelProvider(widget.userid).notifier).toggleCustomArea(true);
    } else {
      ref.read(addServiceProviderViewModelProvider(widget.userid).notifier).toggleCustomArea(false);
    }
  }

  void _onAreaSelected(String area) {
    setState(() {
      shopArea.text = area;
      showDropdown = false;
      addnewArea = false;

    });
    ref.read(addServiceProviderViewModelProvider(widget.userid).notifier).toggleCustomArea(false);
    ref.read(addServiceProviderViewModelProvider(widget.userid).notifier).setLocation(area);
    focus.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: shopArea,
          focusNode: focus,
          decoration: InputDecoration(
            labelText: 'sector/society',
            hintText: 'Search Area',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0.r),
            ),
            suffixIcon: shopArea.text.isNotEmpty
                ? IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  shopArea.clear();
                  showDropdown = true;

                });
                ref.read(addServiceProviderViewModelProvider(widget.userid).notifier).setLocation(null);
              },
            ): null
          ),
          onChanged: (value) {
            ref.read(addServiceProviderViewModelProvider(widget.userid).notifier).setLocation(null);
            RecommendedArea();
          },
          onTap: () {
            setState(() {
              showDropdown = allAreas.isNotEmpty;
            });
          },
        ),

        if (showDropdown && allAreas.isNotEmpty)
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
                  thumbVisibility: true,
                  thickness: 6.0,
                  radius: Radius.circular(3),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),

                    itemCount: allAreas.length,
                    itemBuilder: (context, index) {
                      final area = allAreas[index];
                      return ListTile(
                        title: Text(area) ,
                        onTap: () => _onAreaSelected(area),
                      );

                    },
                  ),
                ),
              ),
            ),
          ),

        if (addnewArea && shopArea.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'No location found!',
              style: TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
}



class updateShopAreaDropDown extends ConsumerStatefulWidget {
  final ServiceProviders service;

  updateShopAreaDropDown({required this.service, Key? key}) : super(key: key);

  @override
  ConsumerState<updateShopAreaDropDown> createState() => _updateShopAreaDropDown();
}

class _updateShopAreaDropDown extends ConsumerState<updateShopAreaDropDown> {
  final TextEditingController shopArea = TextEditingController();
  final FocusNode focus = FocusNode();
  List<String> allAreas = [
    "PWD",
    "DHA Phase I", 'DHA Phase II', 'DHA Phase III', 'DHA PHASE IV', 'DHA Phase V', 'DHA Valley',
    "Bahria Phase 1", "Bahria Phase 2", "Bahria Phase 3", "Bahria Phase 4",
    "Bahria Phase 5", "Bahria Phase 6", "Bahria Phase 7", "Bahria Phase 8",
    "Gulberg Green",
    'Park View City',
    'Golra Morr',
    '6th Road',
    'Murree Road',
    "Soan Garden",
    'Khana Pul',
    "Blue Area",
    "Jinnah Garden,Phase-1", "Jinnah Garden,Phase-2",
    'A-17', 'B-17', 'B-18',
    'D-11', 'D-12', 'D-13', 'D-14', 'D-15', 'D-16', 'D-17',
    'E-7', 'E-8', 'E-9', 'E-10', 'E-11', 'E-12', 'E-13', 'E-14', 'E-15', 'E-16', 'E-17', 'E-18',
    "I-8", "I-9", "I-10", 'I-11', 'I-12', "I-13", 'I-14', 'I-15', 'I-16', 'I-17', '1-18',
    'H-8', 'H-9', 'H-10', 'H-11', 'H-12', 'H-13', 'H-14', 'H-15', 'H-16', 'H-17',
    'G-5', 'G-6', 'G-7', 'G-8', 'G-9', 'G-10', 'G-11', 'G-12', 'G-13', 'G-14', 'G-15', 'G-16', 'G-17',
    'F-5', 'F-6', 'F-7', 'F-8', 'F-9', 'F-10', 'F-11', 'F-12', 'F-13', 'F-14', 'F-15', 'F-16', 'F-17',
    'AGOCHS, Phase-I', 'AGOCHS, Phase-II'
  ];
  bool addnewArea = false;
  bool showDropdown = false;

  @override
  void initState() {
    super.initState();
    // Initialization logic that doesn't rely on inherited widgets
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Move the logic that depends on inherited widgets to didChangeDependencies
    final state = ref.watch(updateServiceProviderViewModelProvider(widget.service).notifier);
    if (state.area != null) {
      shopArea.text = state.area!;
      shopArea.addListener(RecommendedArea);
    }
  }

  @override
  void dispose() {
    shopArea.dispose();
    focus.dispose();
    super.dispose();
  }

  void RecommendedArea() {

    final input = shopArea.text.trim().toLowerCase();
    if (input.isEmpty) {
      setState(() {

        addnewArea = false;
        showDropdown = false;
      });
      return;
    }

    setState(() {
      allAreas = allAreas.where((category) => category != null && category.toLowerCase().contains(input))
          .toList() ;
      addnewArea = allAreas.isEmpty;
      showDropdown = true;
    });


    if (addnewArea) {
      ref.read(updateServiceProviderViewModelProvider(widget.service).notifier).toggleCustomArea(true);
    }
    else {
      ref.read(updateServiceProviderViewModelProvider(widget.service).notifier).toggleCustomArea(false);
    }
  }

  void _onAreaSelected(String area) {
    setState(() {
      shopArea.text = area;
      showDropdown = false;
      addnewArea = false;

    });
    ref.read(updateServiceProviderViewModelProvider(widget.service).notifier).toggleCustomArea(false);
    ref.read(updateServiceProviderViewModelProvider(widget.service).notifier).setLocation(area);
    focus.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: shopArea,
          focusNode: focus,
          decoration: InputDecoration(
            labelText: 'sector/society',
            hintText: 'Search ',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0.r),
            ),
            suffixIcon: shopArea.text.isNotEmpty
                ? IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  shopArea.clear();
                  showDropdown = false;

                });
                ref.read(updateServiceProviderViewModelProvider(widget.service).notifier).setLocation(null);
              },
            ): null,
          ),
          onChanged: (value) {
            ref.read(updateServiceProviderViewModelProvider(widget.service).notifier).setLocation(null); // Reset category while typing
            RecommendedArea();
          },
          onTap: () {
            setState(() {
              // Only show dropdown if there are categories to show
              showDropdown = allAreas.isNotEmpty;
            });
          },
        ),

        if (showDropdown && allAreas.isNotEmpty)
          SingleChildScrollView(
            child: Container(
              height: 200,
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
                  itemCount: allAreas.length,
                  itemBuilder: (context, index) {
                    final category = allAreas[index];
                    return ListTile(
                      title: Text(category),
                      onTap: () => _onAreaSelected(category),
                    );
                  },
                ),
              ),
            ),
          ),

        if (addnewArea && shopArea.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Not available',
              style: TextStyle(color: Colors.red),
            ),

          ),
      ],
    );
  }
}