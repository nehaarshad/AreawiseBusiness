
import 'package:ecommercefrontend/Views/shared/widgets/buttons.dart';
import 'package:ecommercefrontend/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../View_Model/SharedViewModels/transcriptsViewModel.dart';

class OnlinePaymentReciptView extends ConsumerStatefulWidget {
  final int orderId;
  final int sellerId;
  const OnlinePaymentReciptView({super.key,required this.orderId,required this.sellerId,});

  @override
  ConsumerState<OnlinePaymentReciptView> createState() => _OnlinePaymentReciptViewState();
}

class _OnlinePaymentReciptViewState extends ConsumerState<OnlinePaymentReciptView> {



  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(TranscriptsViewModelProvider.notifier).getTranscript(
            widget.sellerId, widget.orderId);
      } });
  }


  @override
  Widget build(BuildContext context) {
    final state=ref.watch(TranscriptsViewModelProvider);
    return  Scaffold(

      appBar: AppBar(
        automaticallyImplyLeading: true,
       
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: Image.network(
            state.Image!,
             fit: BoxFit.contain,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) =>
                Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported),
                ),
          ),
        )

          
            
      ),
    );
  }
}
