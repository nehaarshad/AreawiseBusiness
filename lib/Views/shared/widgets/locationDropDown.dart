import 'package:ecommercefrontend/View_Model/SharedViewModels/locationSelectionViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/utils/colors.dart';

class locationDropDown extends ConsumerStatefulWidget {
  const locationDropDown({super.key});

  @override
  ConsumerState<locationDropDown> createState() => _locationCategoryDropDownState();
}

class _locationCategoryDropDownState extends ConsumerState<locationDropDown> {
  final TextEditingController selectedArea = TextEditingController();
  final FocusNode focus = FocusNode();

  final List<String> _allAreas = [
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

  List<String> areas = [];
  bool showDropdown = false;

  @override
  void initState() {
    super.initState();
    areas = _allAreas;

    // Load saved location if exists
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentLocation = ref.read(selectLocationViewModelProvider);
      if (currentLocation != null) {
        selectedArea.text = currentLocation;
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectedArea.addListener(RecommendedCategories);
  }

  @override
  void dispose() {
    selectedArea.removeListener(RecommendedCategories);
    selectedArea.dispose();
    focus.dispose();
    super.dispose();
  }

  void RecommendedCategories() {
    final input = selectedArea.text.trim().toLowerCase();

    setState(() {
      if (input.isEmpty) {
        areas = _allAreas;
        showDropdown = false;
      } else {
        areas = _allAreas
            .where((area) => area.toLowerCase().contains(input))
            .toList();
        showDropdown = true;
      }
    });
  }

  void _onAreaSelected(String area) {
    setState(() {
      selectedArea.text = area;
      showDropdown = false;
    });
    ref.read(selectLocationViewModelProvider.notifier).setLocation(area);
    focus.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: selectedArea,
                focusNode: focus,
                style: TextStyle(fontSize: 14.sp),
                decoration: InputDecoration(
                  labelText: 'Location',
                  labelStyle: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
                  hintText: 'Search sector/society',
                  hintStyle: TextStyle(fontSize: 13.sp),
                  prefixIcon: Icon(
                    Icons.location_on,
                    color: Appcolors.baseColor,
                    size: 20.sp,
                  ),
                  suffixIcon: selectedArea.text.isNotEmpty
                      ? IconButton(
                    icon: Icon(Icons.clear, size: 18.sp),
                    onPressed: () {
                      setState(() {
                        selectedArea.clear();
                        showDropdown = false;
                        areas = _allAreas;
                      });
                      ref.read(selectLocationViewModelProvider.notifier).setLocation(null);
                    },
                  )
                      : Icon(Icons.arrow_drop_down, color: Colors.grey[600], size: 24.sp),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: Appcolors.baseColor, width: 2),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (value) {
                  RecommendedCategories();
                },
                onTap: () {
                  setState(() {
                    showDropdown = true;
                    if (selectedArea.text.isEmpty) {
                      areas = _allAreas;
                    }
                  });
                },
              ),
            ),

            if (showDropdown && areas.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Container(
                  constraints: BoxConstraints(maxHeight: 100.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Scrollbar(
                      thumbVisibility: true,
                      thickness: 5.0,
                      radius: Radius.circular(4.r),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: areas.length,
                        separatorBuilder: (context, index) => Divider(
                          height: 1,
                          thickness: 0.5,
                          color: Colors.grey[200],
                        ),
                        itemBuilder: (context, index) {
                          final area = areas[index];
                          final isSelected = selectedArea.text == area;

                          return ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                            title: Text(
                              area,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                color: isSelected ? Appcolors.baseColor : Colors.black87,
                              ),
                            ),
                            trailing: isSelected
                                ? Icon(
                              Icons.check_circle,
                              color: Appcolors.baseColor,
                              size: 18.sp,
                            )
                                : null,
                            tileColor: isSelected
                                ? Appcolors.baseColor.withOpacity(0.05)
                                : Colors.transparent,
                            hoverColor: Colors.grey[100],
                            onTap: () => _onAreaSelected(area),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
  }
}