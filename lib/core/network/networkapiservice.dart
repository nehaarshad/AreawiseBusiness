import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:ecommercefrontend/core/network/baseapiservice.dart';
import 'package:ecommercefrontend/core/network/appexception.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

class networkapiservice extends baseapiservice {
  @override
  Future GetApiResponce(String url) async {
    dynamic responseJson;
    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(Duration(seconds: 10));
      responseJson = httpResponse(response);
    } on SocketException {
      throw fetchdataException("No Internet Connnection");
    }
    return responseJson;
  }

  @override
  Future PostApiWithJson(
    String url,
    dynamic data,
    Map<String, String> headers,
  ) async
  {
    dynamic responseJson;
    try {
      Response response = await post(
        Uri.parse(url),
        body: data,
        headers: headers,
      ).timeout(Duration(seconds: 30));

      responseJson = httpResponse(response);
    } on SocketException {
      throw fetchdataException("No Internet Connnection");
    }
    return responseJson;
  }

  Future UpdateApiWithJson(
    String url,
    dynamic data,
    Map<String, String> headers,
  ) async
  {
    dynamic responseJson;
    try {
      Response response = await put(
        Uri.parse(url),
        body: data,
        headers: headers,
      ).timeout(Duration(seconds: 30));

      responseJson = httpResponse(response);
    } on SocketException {
      throw fetchdataException("No Internet Connnection");
    }
    return responseJson;
  }

  Future PostApiWithMultiport(
      String url, Map<String, dynamic> data, List<File>? files,
      ) async
  {
    try {
      final request = new http.MultipartRequest('POST', Uri.parse(url));

      data.forEach((key, value) {
        //to add data into fields
        request.fields[key] = value.toString();
      });
      //upload files of images
      if (files != null) {
        for (var i = 0; i < files.length; i++) {
          final stream = http.ByteStream(files[i].openRead());
          final length = await files[i].length();

          final multipartFile = new http.MultipartFile(
            'image', // matched with api file field keys
            stream,
            length,
            filename: '${DateTime.now().millisecondsSinceEpoch}.jpg',
            contentType: MediaType('image', 'jpeg'),
          );
          request.files.add(multipartFile);
        }
      }
      final streameresponse = await request.send().timeout(
        Duration(seconds: 10),
      );
      final response = await http.Response.fromStream(streameresponse);

      return httpResponse(response);
    } on SocketException {
      throw fetchdataException("No Internet Connnection");
    }
  }

  //update Using Multiport (Multiple File Handler)
  Future UpdateApiWithMultiport(
    String url,
    Map<String, dynamic> data,
    List<File>? files,
  ) async
  {
    try {
      final request = new http.MultipartRequest('PUT', Uri.parse(url));

      data.forEach((key, value) {
        //to add data into fields
        request.fields[key] = value.toString();
      });
      //upload files of images
      if (files != null) {
        for (var i = 0; i < files.length; i++) {
          final stream = http.ByteStream(files[i].openRead());
          final length = await files[i].length();

          final multipartFile = new http.MultipartFile(
            'image', // matched with keys
            stream,
            length,
            filename: '${DateTime.now().millisecondsSinceEpoch}.jpg',
            contentType: MediaType('image', 'jpeg'),
          );
          request.files.add(multipartFile);
        }
      }
      final streameresponse = await request.send().timeout(
        Duration(seconds: 10),
      );
      final response = await http.Response.fromStream(streameresponse);

      return httpResponse(response);
    } on SocketException {
      throw fetchdataException("No Internet Connnection");
    }
  }

  //update Using Multiport (Single File Handler)
  Future<Map<String, dynamic>> SingleFileUpdateApiWithMultiport(
    String url,
    Map<String, dynamic> data,
    File? files,
  ) async
  {
    try {
      final request = new http.MultipartRequest('PUT', Uri.parse(url));

      data.forEach((key, value) {
        //to add data into fields
        request.fields[key] = value.toString();
      });
      //upload files of images
      if (files != null) {
        final stream = http.ByteStream(files.openRead());
        final length = await files.length();

        final multipartFile = new http.MultipartFile(
          'image', // matched with keys
          stream,
          length,
          filename: '${DateTime.now().millisecondsSinceEpoch}.jpg',
          contentType: MediaType('image', 'jpeg'), // Set MIME type
        );
        request.files.add(multipartFile);
      }
      final streameresponse = await request.send().timeout(
        Duration(seconds: 10),
      );
      final response = await http.Response.fromStream(streameresponse);

      return httpResponse(response);
    } on SocketException {
      throw fetchdataException("No Internet Connnection");
    }
  }

  Future DeleteApiResponce(String url) async
  {
    dynamic responseJson;
    try {
      Response response = await delete(
        Uri.parse(url),
      ).timeout(Duration(seconds: 10));

      responseJson = httpResponse(response);
    } on SocketException {
      throw fetchdataException("No Internet Connnection");
    }
    return responseJson;
  }

  @override
  Future DeleteApiWithJson(String url, data, Map<String, String> headers) async{
    dynamic responseJson;
    try {
      Response response = await delete(
        Uri.parse(url),
        body: data,
        headers: headers,
      ).timeout(Duration(seconds: 30));

      responseJson = httpResponse(response);
    } on SocketException {
      throw fetchdataException("No Internet Connnection");
    }
    return responseJson;
  }

  dynamic httpResponse(http.Response res) {
    switch (res.statusCode) {
      case 200: //success
        dynamic responseJson = jsonDecode(res.body);
        return responseJson;
      case 201: //created
        dynamic responseJson = jsonDecode(res.body);
        return responseJson;
      case 400: //invalid input ,type errors...
        throw badrequestException(res.body.toString());
      case 500:
      case 404:
        throw unauthorizeException(res.body.toString());
      default:
        throw fetchdataException(
          "Error occur while communication with server \t Status Code:" +
              res.statusCode.toString(),
        );
    }
  }

}
