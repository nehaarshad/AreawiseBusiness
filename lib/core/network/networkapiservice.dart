import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:ecommercefrontend/core/network/baseapiservice.dart';
import 'package:ecommercefrontend/core/network/appexception.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;


class networkapiservice implements baseapiservice {
  @override
  Future GetApiResponce(String url, Map<String, String> headers,) async {
    dynamic responseJson;
    print(headers);
    try {
      final response = await http
          .get(Uri.parse(url), headers: headers,)
          .timeout(Duration(seconds: 10));
      print(response.headers);
      print("subcategoryproducts ${response.body}");
      responseJson = httpResponse(response);

    } on SocketException {
      throw fetchdataException("No Internet Connection");
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
      print("in header sent ${headers}");
      Response response = await post(
        Uri.parse(url),
        body: data,
        headers: headers,
      ).timeout(Duration(seconds: 30));

      responseJson = httpResponse(response);
    } on SocketException {
      throw fetchdataException("No Internet Connection");
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
      print("in header sent ${headers}");
      print("url and data sent ${url} ${data}");
      Response response = await put(
        Uri.parse(url),
        body: data,
        headers: headers,
      ).timeout(Duration(seconds: 30));
      print("res ${response.body}");
      responseJson = httpResponse(response);
    } on SocketException {
      throw fetchdataException("No Internet Connection");
    }
    return responseJson;
  }

  Future PostApiWithMultiport(
      String url, Map<String, dynamic> data, List<File>? files, Map<String, String> headers,
      ) async
  {
    try {
      final request = new http.MultipartRequest('POST', Uri.parse(url),);

      data.forEach((key, value) {
        //to add data into fields
        request.fields[key] = value.toString();
      });
      final authHeader = headers['Authorization'];
      final token = authHeader?.split(' ').last;
      print("inMultiport post token ${token}");
      request.headers['Content-Type'] = 'multipart/form-data';
      request.headers['Authorization'] = 'Bearer $token';
      print("inMultiport headers ${request.headers}");
      //upload files of images
      if (files != null && files.isNotEmpty) {
        for (var i = 0; i < files.length; i++) {
          try {
            // Compress image before upload
            final compressedFile = await compressImage(files[i]);
            if (compressedFile == null) continue;

            final stream = http.ByteStream(compressedFile.openRead());
            final length = await compressedFile.length();

            final multipartFile = http.MultipartFile(
              'image', // Field name matching backend
              stream,
              length,
              filename: '${DateTime.now().millisecondsSinceEpoch}_$i.jpg',
              contentType: MediaType('image', 'jpeg'),
            );

            request.files.add(multipartFile);
            print("Added compressed image ${i + 1}, size: ${length} bytes");
          } catch (e) {
            print('Error processing file $i: $e');
            continue;
          }
        }
      }

      print("Uploading ${request.files.length} files");
      final streameresponse = await request.send().timeout(
        Duration(seconds: 30),
      );
      final response = await http.Response.fromStream(streameresponse);

      return httpResponse(response);
    } on SocketException {
      throw fetchdataException("No Internet Connection");
    }
  }

  Future PostApiWithExcelFile(
      String url,File? files,
      ) async
  {
    try {
      final request = new http.MultipartRequest('POST', Uri.parse(url),);

      print("inMultiport headers ${request.headers}");
      //upload files of images
      if (files != null ) {
          try {

            final stream = http.ByteStream(files.openRead());
            final length = await files.length();

            final multipartFile = http.MultipartFile(
              'data0', // Field name matching backend
              stream,
              length,
            );

            request.files.add(multipartFile);
          } catch (e) {
            print('Error processing file : $e');

          }
        }


      print("Uploading ${request.files.length} files");
      final streameresponse = await request.send().timeout(
        Duration(seconds: 30),
      );
      final response = await http.Response.fromStream(streameresponse);

      return httpResponse(response);
    } on SocketException {
      throw fetchdataException("No Internet Connection");
    }
  }


  //update Using Multiport (Multiple File Handler)
  Future UpdateApiWithMultiport(
    String url,
    Map<String, dynamic> data,
    List<File>? files,
      Map<String, String> headers,
  ) async
  {
    try {
      final request = new http.MultipartRequest('PUT', Uri.parse(url));

      data.forEach((key, value) {
        //to add data into fields
        request.fields[key] = value.toString();
      });
      final authHeader = headers['Authorization'];
      final token = authHeader?.split(' ').last;
      print("inMultiport post token ${token}");
      request.headers['Content-Type'] = 'multipart/form-data';
      request.headers['Authorization'] = 'Bearer $token';
      print("inMultiport headers ${request.headers}");
      //upload files of images
      if (files != null && files.isNotEmpty) {
        for (var i = 0; i < files.length; i++) {
          try {
            final compressedFile = await compressImage(files[i]);
            if (compressedFile == null) continue;

            final stream = http.ByteStream(compressedFile.openRead());
            final length = await compressedFile.length();

            final multipartFile = http.MultipartFile(
              'image',
              stream,
              length,
              filename: '${DateTime.now().millisecondsSinceEpoch}_$i.jpg',
              contentType: MediaType('image', 'jpeg'),
            );

            request.files.add(multipartFile);
          } catch (e) {
            print('Error processing file $i: $e');
            continue;
          }
        }
      }

      final streameresponse = await request.send().timeout(
        Duration(seconds: 30),
      );
      final response = await http.Response.fromStream(streameresponse);

      return httpResponse(response);
    } on SocketException {
      throw fetchdataException("No Internet Connection");
    }
  }

  Future<Map<String, dynamic>> SingleFileUploadApiWithMultiport(
      String url,
      Map<String, dynamic> data,
      File? files,
      Map<String, String> headers,
      ) async
  {
    try {
      final request = new http.MultipartRequest('POST', Uri.parse(url));

      data.forEach((key, value) {
        //to add data into fields
        request.fields[key] = value.toString();
      });

      final authHeader = headers['Authorization'];
      final token = authHeader?.split(' ').last;
      print("inMultiport post token ${token}");
      request.headers['Content-Type'] = 'multipart/form-data';
      request.headers['Authorization'] = 'Bearer $token';

      print("inMultiport headers ${request.headers}");
      //upload files of images
      print(files);
      if (files != null) {
        final compressedFile = await compressImage(files);
        if (compressedFile != null) {
          final stream = http.ByteStream(compressedFile.openRead());
          final length = await compressedFile.length();

          final multipartFile = http.MultipartFile(
            'image',
            stream,
            length,
            filename: '${DateTime.now().millisecondsSinceEpoch}.jpg',
            contentType: MediaType('image', 'jpeg'),
          );

          request.files.add(multipartFile);
          print("Compressed file size: ${length} bytes");
        }
      }
      final streameresponse = await request.send().timeout(
        Duration(seconds: 30),
      );
      final response = await http.Response.fromStream(streameresponse);

      return httpResponse(response);
    } on SocketException {
      throw fetchdataException("No Internet Connection");
    }
  }
  //update Using Multiport (Single File Handler)
  Future<Map<String, dynamic>> SingleFileUpdateApiWithMultiport(
    String url,
    Map<String, dynamic> data,
    File? files,
      Map<String, String> headers,
  ) async
  {
    try {
      final request = new http.MultipartRequest('PUT', Uri.parse(url));

      data.forEach((key, value) {
        //to add data into fields
        request.fields[key] = value.toString();
      });
      final authHeader = headers['Authorization'];
      final token = authHeader?.split(' ').last;
      print("inMultiport post token ${token}");
      request.headers['Content-Type'] = 'multipart/form-data';
      request.headers['Authorization'] = 'Bearer $token';

      print("inMultiport headers ${request.headers}");
      //upload files of images
      if (files != null) {
        final compressedFile = await compressImage(files);
        if (compressedFile != null) {
          final stream = http.ByteStream(compressedFile.openRead());
          final length = await compressedFile.length();

          final multipartFile = http.MultipartFile(
            'image',
            stream,
            length,
            filename: '${DateTime.now().millisecondsSinceEpoch}.jpg',
            contentType: MediaType('image', 'jpeg'),
          );

          request.files.add(multipartFile);
        }
      }
      final streameresponse = await request.send().timeout(
        Duration(seconds: 30),
      );
      final response = await http.Response.fromStream(streameresponse);

      return httpResponse(response);
    } on SocketException {
      throw fetchdataException("No Internet Connection");
    }
  }

  Future DeleteApiResponce(String url, Map<String, String> headers,) async
  {
    dynamic responseJson;
    try {
      Response response = await delete(
        Uri.parse(url),headers: headers
      ).timeout(Duration(seconds: 10));

      responseJson = httpResponse(response);
    } on SocketException {
      throw NoInternetException("No Internet Connection");
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
    } catch(e) {

    }
    return responseJson;
  }

  Future<File?> compressImage(File file) async {
    try {
      final dir = await getTemporaryDirectory();
      final targetPath = path.join(
          dir.path,
          '${DateTime.now().millisecondsSinceEpoch}_compressed.jpg'
      );

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 85, // Match backend quality
        minWidth: 800, // Match backend max width
        minHeight: 800, // Match backend max height
        format: CompressFormat.jpeg,
      );

      return compressedFile != null ? File(compressedFile.path) : null;
    } catch (e) {
      print('Error compressing image: $e');
      return file; // Return original if compression fails
    }
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
        throw badrequestException("Invalid input ");
      case 500:
      case 404:
        throw unauthorizeException("Unauthorized access");
      default:
        throw NoInternetException(
          "No Internet Connection"
        );
    }
  }


}
