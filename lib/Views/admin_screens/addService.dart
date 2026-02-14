import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../View_Model/adminViewModels/servicesViewModel.dart';

class addService extends ConsumerStatefulWidget {

  const addService();

  @override
  ConsumerState<addService> createState() => _addServiceState();
}

class _addServiceState extends ConsumerState<addService> {

  late final serviceViewModel _viewModel;

  final TextEditingController name=TextEditingController();
  @override
  void initState() {
    super.initState();
    Future.microtask(() { // Runs after build completes
      _viewModel = ref.read(serviceViewModelProvider.notifier);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = ref.watch(serviceViewModelProvider);
    final key = GlobalKey<FormState>();


    return Scaffold(
      appBar: AppBar(

        backgroundColor: Appcolors.whiteSmoke,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Upload Section
              GestureDetector(
                onTap: () {
                  ref.read(serviceViewModelProvider.notifier).pickImages(context);
                },
                child: Container(
                  height: 200.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0.r),
                  ),
                  child: service.image != null ? Image.file(service.image!, fit: BoxFit.cover,) : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.upload, size: 50.h, color: Colors.grey[600]),
                      SizedBox(height: 8),
                      Text("Tap to upload image", style: TextStyle(color: Colors.grey[600]),),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              TextFormField(
                controller: name,
                decoration: InputDecoration(
                  labelText: "Service Name",
                  hintText: "Appliance Repair",
                  prefixIcon: Icon(Icons.miscellaneous_services_sharp),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter service name";
                  }
                  return null;
                },
              ),

              SizedBox(height: 32.h),
              ElevatedButton(
                onPressed: service.isLoading ? null : () async {
                  await ref.read(serviceViewModelProvider.notifier).addService(name.text.trim(),context);
                  name.text='';
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  backgroundColor: Appcolors.baseColor,
                ),
                child: service.isLoading ? CircularProgressIndicator(color: Appcolors.whiteSmoke, )
                    : Text("Submit", style: TextStyle(fontSize: 16.sp,color: Appcolors.whiteSmoke, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
