import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommercefrontend/View_Model/adminViewModels/servicesViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/routes/routes_names.dart';
import '../../core/utils/textStyles.dart';
import '../../core/utils/colors.dart';
import '../shared/widgets/loadingState.dart';

class AllServices extends ConsumerStatefulWidget {
  final String isAdmin;
  const AllServices({super.key,required this.isAdmin});

  @override
  ConsumerState<AllServices> createState() => _AllServicesState();
}

class _AllServicesState extends ConsumerState<AllServices> {
  final TextEditingController _categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(serviceViewModelProvider.notifier).getServices();
    });
  }

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
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
    final servicesStates = ref.watch(serviceViewModelProvider);
    final viewmodel=ref.read(serviceViewModelProvider.notifier);
    return Scaffold(
        backgroundColor: Appcolors.whiteSmoke,
        appBar: AppBar(
          title:  Text(
              ' Services',
              style: AppTextStyles.headline
          ),
          backgroundColor: Appcolors.whiteSmoke,
          actions: [
            widget.isAdmin == "Admin" ? TextButton(onPressed: (){
              Navigator.pushNamed(context, routesName.addServices);
            }, child: Padding(
              padding:  EdgeInsets.only(right: 5.0),
              child: Text("+ Add"),
            ))
                :
                SizedBox.shrink()
          ],
        ),
        body: servicesStates.isLoading ? const Column(
          children: [
            ShimmerListTile(),
            ShimmerListTile(),
            ShimmerListTile(),
            ShimmerListTile(),
          ],
        ): (servicesStates.services != null)
            ? viewmodel.Service(servicesStates.services!,null,widget.isAdmin)
            : SizedBox.shrink()

    );
  }


}