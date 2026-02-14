import 'package:ecommercefrontend/View_Model/adminViewModels/servicesViewModel.dart';
import 'package:ecommercefrontend/Views/shared/widgets/loadingState.dart';
import 'package:ecommercefrontend/core/utils/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/utils/routes/routes_names.dart';

class selectService extends ConsumerStatefulWidget {
  final String id;
  const selectService({required this.id});

  @override
  ConsumerState<selectService> createState() => _selectServiceState();
}

class _selectServiceState extends ConsumerState<selectService> {

  @override

  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(serviceViewModelProvider.notifier).getServices();
    });
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(serviceViewModelProvider.notifier).getServices();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final state=ref.watch(serviceViewModelProvider);
    final model = ref.read(serviceViewModelProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Service",style: AppTextStyles.headline,),

      ),
      body: state.isLoading ? const Column(
        children: [
          ShimmerListTile(),
          ShimmerListTile(),
          ShimmerListTile(),
          ShimmerListTile(),
        ],
      ): (state.services != null)
          ? model.Service(state.services!,widget.id,"Seller")
          : SizedBox.shrink()
    );
  }
}
