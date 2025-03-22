import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import '../helpers/prefs_helper.dart';
import '../utils/app_constants.dart';
import 'api_constants.dart';
import 'error_response.dart';

class ApiClient extends GetxService {
  static var client = http.Client();
  static const String noInternetMessage = "Can't connect to the internet!";
  static const int timeoutInSeconds = 30;
  static String bearerToken = "";

//==========================================> Get Data <======================================
  static Future<Response> getData(String uri,
      {Map<String, dynamic>? query, Map<String, String>? headers}) async {
    bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);

    var mainHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken'
    };
    try {
      debugPrint(
          '====> API Call: ${ApiConstants.baseUrl}$uri\nHeader: ${headers ?? mainHeaders}');

      http.Response response = await client
          .get(
            Uri.parse(ApiConstants.baseUrl + uri),
            headers: headers ?? mainHeaders,
          )
          .timeout(const Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      debugPrint('------------${e.toString()}');
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  //==========================================> Get data by full url <======================================
  static Future<Response> getDataDemo(String uri,
      {Map<String, String>? headers}) async {
    try {
      debugPrint(
          '====> API Call: ${ApiConstants.baseUrl}$uri\nHeader: $headers');

      http.Response response = await client
          .get(
            Uri.parse(uri),
            headers: headers,
          )
          .timeout(const Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      debugPrint('------------${e.toString()}');
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

//==========================================> Post Data <======================================
  static Future<Response> postData(String uri, dynamic body,
      {Map<String, String>? headers}) async {
    String bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);

    var mainHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken'
    };

    try {
      debugPrint('====> API Call: $uri\nHeader: $mainHeaders');
      debugPrint('====> API Body: $body');

      http.Response response = await client
          .post(
            Uri.parse(ApiConstants.baseUrl + uri),
            body: body,
            headers: headers ?? mainHeaders,
          )
          .timeout(const Duration(seconds: timeoutInSeconds));

      debugPrint("==========> Response Post Method : ${response.statusCode}");
      return handleResponse(response, uri);
    } catch (e, s) {
      debugPrint("===> Error in postData: $e");
      debugPrint("===> Error in postData: $s");
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  //==========================================> patch<======================================
  static Future<Response> patch(String uri, var body,
      {Map<String, String>? headers}) async {
    bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);

    var mainHeaders = {
      // 'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken'
    };
    try {
      debugPrint('====> API Call: $uri\nHeader: ${headers ?? mainHeaders}');
      debugPrint('====> API Body: $body');

      http.Response response = await client
          .patch(
            Uri.parse(ApiConstants.baseUrl + uri),
            body: body,
            headers: headers ?? mainHeaders,
          )
          .timeout(const Duration(seconds: timeoutInSeconds));
      debugPrint(
          "==========> Response Post Method :------ : ${response.statusCode}");
      return handleResponse(response, uri);
    } catch (e) {
      print("===> $e");
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  /// ==========================================> postMultipartData =======================================>

  static Future<Response> postMultipartData(
      String uri, Map<String, String> body,
      {required List<MultipartBody> multipartBody,
      Map<String, String>? headers}) async {
    try {
      bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);

      var mainHeaders = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $bearerToken'
      };

      debugPrint('====> API Call: $uri\nHeader: ${headers ?? mainHeaders}');
      debugPrint('====> API Body: $body with ${multipartBody.length} picture');
      var request =
          http.MultipartRequest('POST', Uri.parse(ApiConstants.baseUrl + uri));
      request.headers.addAll(headers ?? mainHeaders);
      for (MultipartBody element in multipartBody) {
        request.files.add(await http.MultipartFile.fromPath(
          element.key,
          element.file.path,
        ));
      }
      request.fields.addAll(body);
      http.Response response =
          await http.Response.fromStream(await request.send());
      return handleResponse(response, uri);
    } catch (e, s) {
      print("==================$s");
      print("==================$s");
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

//==========================================> Put Data <======================================
  Future<Response> putData(String uri, dynamic body,
      {Map<String, String>? headers}) async {
    bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);

    var mainHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken'
    };
    try {
      debugPrint('====> API Call: $uri\nHeader: ${headers ?? mainHeaders}');
      debugPrint('====> API Body: $body');

      http.Response response = await http
          .put(
            Uri.parse(ApiConstants.baseUrl + uri),
            body: jsonEncode(body),
            headers: headers ?? mainHeaders,
          )
          .timeout(const Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  //==========================================> Put Multipart Data <======================================
  static Future<Response> putMultipartData(String uri, Map<String, String> body,
      {List<MultipartBody>? multipartBody,
      List<MultipartListBody>? multipartListBody,
      Map<String, String>? headers}) async {
    try {
      // Fetch bearer token from preferences
      bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);

      // Set up main headers with Authorization and Content-Type for multipart data
      var mainHeaders = {
        'Content-Type': 'multipart/form-data', // Change to multipart form-data
        'Authorization': 'Bearer $bearerToken'
      };

      // Log API Call details for debugging
      debugPrint('====> API Call: $uri\nHeader: ${headers ?? mainHeaders}');
      debugPrint(
          '====> API Body: $body with ${multipartBody?.length ?? 0} picture');

      // Create a MultipartRequest for PUT
      var request =
          http.MultipartRequest('PUT', Uri.parse(ApiConstants.baseUrl + uri));
      request.fields.addAll(body); // Add fields to request

      // Check if multipartBody exists and is not empty
      if (multipartBody != null && multipartBody.isNotEmpty) {
        for (var element in multipartBody) {
          debugPrint("path : ${element.file.path}");
          // Check if the file exists
          if (element.file.existsSync()) {
            String? mimeType = mime(element.file.path);
            // Add file to the multipart request
            request.files.add(await http.MultipartFile.fromPath(
              element.key,
              element.file.path,
              contentType: MediaType.parse(mimeType!),
            ));
          } else {
            debugPrint("File does not exist: ${element.file.path}");
          }
        }
      }

      // Add headers to the request
      request.headers.addAll(mainHeaders);

      // Send the request and get the streamed response
      http.StreamedResponse response = await request.send();
      // Convert streamed response to a string
      final content = await response.stream.bytesToString();

      // Log API response details
      debugPrint('====> API Response: [${response.statusCode}] $uri\n$content');

      // Return response with status code, body, and other details
      return Response(
        statusCode: response.statusCode,
        statusText: response.statusCode == 200 ? 'Success' : noInternetMessage,
        body: json.decode(content),
      );
    } catch (e, s) {
      // Handle any exceptions and print error details
      print("==================================== Error: $e");
      print("==================================== Stacktrace: $s");
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  //==========================================> Patch Multipart Data <======================================
  static Future<Response> patchMultipartData(
      String uri, Map<String, String> body,
      {List<MultipartBody>? multipartBody,
      List<MultipartListBody>? multipartListBody,
      Map<String, String>? headers}) async {
    try {
      bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);
      // bearerToken = PrefsHelper.token;

      var mainHeaders = {
        // 'Content-Type': 'application/json',
        'Authorization': 'Bearer $bearerToken'
      };

      debugPrint('====> API Call: $uri\nHeader: ${headers ?? mainHeaders}');
      debugPrint('====> API Body: $body with ${multipartBody?.length} picture');
      var request =
          http.MultipartRequest('PATCH', Uri.parse(ApiConstants.baseUrl + uri));
      request.fields.addAll(body);

      if (multipartBody!.isNotEmpty) {
        multipartBody.forEach((element) async {
          debugPrint("path : ${element.file.path}");
          String? mimeType = mime(element.file.path);
          request.files.add(http.MultipartFile(
            element.key,
            element.file.readAsBytes().asStream(),
            element.file.lengthSync(),
            filename: element.file.path.split('/').last,
            contentType: MediaType.parse(mimeType!),
          ));
        });
      }
      request.headers.addAll(mainHeaders);
      http.StreamedResponse response = await request.send();
      final content = await response.stream.bytesToString();
      debugPrint(
          '====> API Response: [${response.statusCode}}] $uri\n$content');

      return Response(
          statusCode: response.statusCode,
          statusText: noInternetMessage,
          body: json.decode(content));
    } catch (e) {
      print("====================================e $e");
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  //==========================================> Delete Data <======================================
  static Future<Response> deleteData(String uri,
      {Map<String, String>? headers, dynamic body}) async {
    bearerToken = await PrefsHelper.getString(AppConstants.bearerToken);

    var mainHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken'
    };
    try {
      debugPrint('====> API Call: $uri\nHeader: ${headers ?? mainHeaders}');
      debugPrint('====> API Call: $uri\n Body: $body');

      http.Response response = await http
          .delete(Uri.parse(ApiConstants.baseUrl + uri),
              headers: headers ?? mainHeaders, body: body)
          .timeout(const Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  //==========================================> Handle Response <======================================
  static Response handleResponse(http.Response response, String uri) {
    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (e) {
      debugPrint(e.toString());
    }
    Response response0 = Response(
      body: body ?? response.body,
      bodyString: response.body.toString(),
      request: Request(
          headers: response.request!.headers,
          method: response.request!.method,
          url: response.request!.url),
      headers: response.headers,
      statusCode: response.statusCode,
      statusText: response.reasonPhrase,
    );
    if (response0.statusCode != 200 &&
        response0.body != null &&
        response0.body is! String) {
      ErrorResponse errorResponse = ErrorResponse.fromJson(response0.body);
      response0 = Response(
          statusCode: response0.statusCode,
          body: response0.body,
          statusText: errorResponse.message);
    } else if (response0.statusCode != 200 && response0.body == null) {
      response0 = const Response(statusCode: 0, statusText: noInternetMessage);
    }

    debugPrint(
        '====> API Response: [${response0.statusCode}] $uri\n${response0.body}');
    return response0;
  }
}

class MultipartBody {
  String key;
  File file;

  MultipartBody(this.key, this.file);
}

class MultipartListBody {
  String key;
  String value;
  MultipartListBody(this.key, this.value);
}
