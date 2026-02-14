import 'package:ecommercefrontend/View_Model/adminViewModels/updateServiceViewModel.dart';
import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:ecommercefrontend/core/utils/dialogueBox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../View_Model/adminViewModels/servicesViewModel.dart';
import '../shared/widgets/loadingState.dart';

class updateService extends ConsumerStatefulWidget {
  final String id;
  const updateService({required this.id});

  @override
  ConsumerState<updateService> createState() => _updateServiceState();
}

class _updateServiceState extends ConsumerState<updateService> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() { // Runs after build completes
      ref.read(updateServiceViewModelProvider(widget.id).notifier);
    });
  }

  Widget buildStatusDropdown(updateServiceViewModel model, String status) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: model.status, // Ensure this matches one of the available items
          decoration: InputDecoration(
            labelText: "Status",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0.r),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please select a role";
            }
            return null;
          },
          onChanged: (value) {
            setState(() {
              model.status = value!;
            });
          },
          items: [
            DropdownMenuItem(value: "Active", child: Text("Active")),
            DropdownMenuItem(value: "Requested", child: Text("Deactivate")),
          ].where((item) => item != null).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = ref.watch(updateServiceViewModelProvider(widget.id));
    final model=ref.read(updateServiceViewModelProvider(widget.id).notifier);
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Service"),
        backgroundColor: Appcolors.whiteSmoke,
      ),
      body: service.when(
          data: (service){
            if(service==null ){
              return Center(child: Text("No Service details Found"),);
            }
          return  SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Image Upload Section
                  model.serviceImage(service, context),

                  SizedBox(height: 24.h),

                  TextFormField(
                    controller: model.name,
                    decoration: InputDecoration(
                      labelText: "Service Name",
                      hintText: "Appliance Repair",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0.r),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter service name";
                      }
                      return null;
                    },
                  ),
                 SizedBox(height: 10.h,),
                 buildStatusDropdown(model, service.status!),

                  SizedBox(height: 32.h),
                  ElevatedButton(
                    onPressed: () async {
                             await ref.read(updateServiceViewModelProvider(widget.id).notifier).updateService(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      backgroundColor: Appcolors.baseColor,
                    ),
                    child:Text("Save Changes", style: TextStyle(fontSize: 16.sp,color: Appcolors.whiteSmoke, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),

            );
          }, error: (err, stack) => Center(child: Text('Error: $err')),
        loading: () => const ShimmerListTile(),
      )
    );
  }
}
