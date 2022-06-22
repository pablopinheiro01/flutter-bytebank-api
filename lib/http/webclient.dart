import 'dart:convert';

import 'package:bytebank/models/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';
import 'package:http_interceptor/http/interceptor_contract.dart';
import 'package:http_interceptor/models/request_data.dart';
import 'package:http_interceptor/models/response_data.dart';

import '../models/contact.dart';
import 'interceptors/logging_interceptor.dart';

Client client = InterceptedClient.build(interceptors: [
  LoggingInterceptor(),
],
requestTimeout: Duration(seconds: 5));

const String base_url = 'http://192.168.15.90:8081/transactions';



