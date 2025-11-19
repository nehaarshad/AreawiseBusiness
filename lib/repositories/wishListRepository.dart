import 'dart:convert';
import 'package:ecommercefrontend/models/wishListModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../View_Model/auth/sessionmanagementViewModel.dart';
import '../core/network/baseapiservice.dart';
import '../core/network/networkapiservice.dart';
import '../core/network/app_APIs.dart';

final wishListProvider=Provider<wishListRepository>((ref){
   return wishListRepository(ref);
});

class wishListRepository{
  Ref ref;

  wishListRepository(this.ref);

  Map<String, String> headers() {
    final token = ref.read(sessionProvider)?.token;
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  baseapiservice apiservice = networkapiservice();

  Future<wishListModel> addToWishList(String id, int productId) async {
    try {
      final data = jsonEncode({'productId': productId});
      dynamic response = await apiservice.PostApiWithJson(
        AppApis.AddToWishListEndPoints.replaceFirst(':id', id),
        data,
        headers(),
      );
        return wishListModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<wishListModel?>> getUserWishList(String id)async{
    List<wishListModel> wishlist = [];
    try{
      dynamic response=await apiservice.GetApiResponce(AppApis.GetWishListofUserEndPoints.replaceFirst(':id', id), headers(),);
      if (response is List) {
        return response.map((products) => wishListModel.fromJson(products as Map<String, dynamic>),).toList();
      }
      wishlist = [wishListModel.fromJson(response)];
      return wishlist;
    }catch(e){
      rethrow;
    }
  }

  Future<dynamic> removeItemFromWishList(String id,int productId) async{
    try{
      final data = jsonEncode({'productId': productId});
      dynamic response=await apiservice.DeleteApiWithJson(AppApis.RemoveFromWishListEndPoints.replaceFirst(':id', id),data, headers(),);
      return response;
    }catch(e){
      rethrow ;
    }
  }
}