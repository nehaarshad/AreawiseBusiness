import 'dart:io';

abstract class baseapiservice {

  Future<dynamic> GetApiResponce(String url, Map<String, String> headers,);
  Future<dynamic> PostApiWithJson(String url, dynamic data, Map<String, String> headers,);
  Future UpdateApiWithJson(String url, dynamic data, Map<String, String> headers,);
  Future PostApiWithMultiport(String url, Map<String, dynamic> data, List<File>? files, Map<String, String> headers,);
  Future<dynamic> UpdateApiWithMultiport(String url, Map<String, dynamic> data, List<File>? files, Map<String, String> headers,);
  Future SingleFileUploadApiWithMultiport(String url, Map<String, dynamic> data, File? files, Map<String, String> headers,);
  Future SingleFileUpdateApiWithMultiport(String url, Map<String, dynamic> data, File? files, Map<String, String> headers,);
  Future<dynamic> DeleteApiResponce(String url, Map<String, String> headers,);
  Future<dynamic> DeleteApiWithJson(String url,dynamic data,Map<String, String> headers,);
}
