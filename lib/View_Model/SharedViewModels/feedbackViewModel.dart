import 'package:ecommercefrontend/models/feedbackModel.dart';
import 'package:ecommercefrontend/repositories/feedbackRepository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommercefrontend/core/utils/routes/routes_names.dart';
import 'package:ecommercefrontend/core/utils/utils.dart';
import 'package:ecommercefrontend/repositories/auth_repositories.dart';
import 'package:flutter/material.dart';

final feedbackVMProvider = StateNotifierProvider<feedbackViewModel, AsyncValue<List<feedbackModel>>>((ref) {
  return feedbackViewModel(ref);
});

class feedbackViewModel extends StateNotifier<AsyncValue<List<feedbackModel>>> {
  final Ref ref;
  feedbackViewModel(this.ref) : super(AsyncValue.loading()) {
    getFeedback();
  }

  Future<void> submitResponse(String email,String comment, BuildContext context) async {
    state = AsyncValue.loading();

    try {
      final data={
        'email':email,
        'comment':comment
      };
      dynamic response = await ref.read(feedbackProvider).addFeedback(data);
      getFeedback();
      Utils.flushBarErrorMessage('Submitted!', context);
    } catch (error) {

      throw error;
    }
  }

  Future<void> getFeedback() async{

  try{
    List<feedbackModel> feedbacks = await ref.read(feedbackProvider).getFeedback();
    state=AsyncValue.data(feedbacks.isNotEmpty ? feedbacks :[]);

  }catch(e){
    throw e;
  }
  }

}
