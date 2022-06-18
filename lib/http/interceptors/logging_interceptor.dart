import 'package:flutter/cupertino.dart';
import 'package:http_interceptor/http/interceptor_contract.dart';
import 'package:http_interceptor/models/request_data.dart';
import 'package:http_interceptor/models/response_data.dart';

class LoggingInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    debugPrint('Request:');
    debugPrint('url : ${data.url}');
    debugPrint('headers : ${data.headers}');
    debugPrint('body : ${data.body}');
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    debugPrint('Response:');
    debugPrint('statusCode : ${data.statusCode}');
    debugPrint('headers : ${data.headers}');
    debugPrint('body : ${data.body}');
    return data;
  }
}