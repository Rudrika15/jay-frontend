import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../exception/api_exception.dart';
import 'package:http/http.dart' as http;

enum HttpRequestType { delete, post, get, put, patch }

class RestApiService {
  Future<http.Response> invokeApi(
      {required String url,
      required HttpRequestType requestType,
      Map<String, String>? header,
      dynamic body}) async {
    final parsedUrl = Uri.parse(url);
    printParameters(url: url,requestType: requestType,header: header,body: body);
    try {
      final request =
          await http.Request(requestType.name.toUpperCase(), parsedUrl);
      if (header != null) {
        request.headers.addAll(header);
      }
      if (body != null) {
        request.body = body;
      }
      final response = await request.send();
      final data = await http.Response.fromStream(response);
      final responseBody = jsonDecode(data.body);
      printResponse(response: response, responseBody: responseBody);
      if (response.statusCode == 201 || response.statusCode == 200) {
        if (responseBody['status'].toString() == 'true') {
          return data;
        } else {
          throw ApiException(responseBody);
        }
      } else {
        throw ApiException(responseBody);
      }
    } on SocketException catch (e) {
      printException(e);
      throw SocketException('No internet connection');
    } on FormatException catch (e) {
      printException(e);
      throw FormatException(
          'Unable to process the server response. Please try again.');
    } on TimeoutException catch (e) {
      printException(e);
      throw Exception('Request timed out. Please try again later.');
    } catch (e) {
      printException(e);
      throw Exception(e);
    }
  }

  void printException(dynamic e) {
    if (kDebugMode || kReleaseMode) {
      print('=====Exception====================================');
      print(e);
      print('==================================================');
    }
  }

  void printResponse(
      {required http.StreamedResponse response, required dynamic responseBody}) {
    if (kDebugMode || kReleaseMode) {
      print('=====Response=====================================');
      print(response.statusCode);
      print(responseBody);
      print('==================================================');
    }
  }

  void printParameters(
      {required String url,
        HttpRequestType requestType = HttpRequestType.delete,
        Map<String, String>? header,
        Object? body}) {
    print('=====Parameters=============================================');
    print('Url : $url');
    print('Header : $header');
    print('Body : $body');
    print('Request type : ${requestType.name}');
    print('==================================================');
  }
}
