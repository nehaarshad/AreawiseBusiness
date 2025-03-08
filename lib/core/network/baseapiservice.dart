import 'dart:io';

abstract class baseapiservice {

  Future<dynamic> GetApiResponce(String url);
  Future<dynamic> PostApiWithJson(String url, dynamic data, Map<String, String> headers,);
  Future UpdateApiWithJson(String url, dynamic data, Map<String, String> headers,);
  Future PostApiWithMultiport(String url, Map<String, dynamic> data, List<File>? files,);
  Future<dynamic> UpdateApiWithMultiport(String url, Map<String, dynamic> data, List<File>? files,);
  Future SingleFileUploadApiWithMultiport(String url, Map<String, dynamic> data, File? files,);
  Future SingleFileUpdateApiWithMultiport(String url, Map<String, dynamic> data, File? files,);
  Future<dynamic> DeleteApiResponce(String url);
  Future<dynamic> DeleteApiWithJson(String url,dynamic data,Map<String, String> headers,);
}
