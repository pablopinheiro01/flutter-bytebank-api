import 'dart:convert';

import 'package:bytebank/models/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';
import 'package:http_interceptor/http/interceptor_contract.dart';
import 'package:http_interceptor/models/request_data.dart';
import 'package:http_interceptor/models/response_data.dart';

import '../models/contact.dart';

Client client = InterceptedClient.build(interceptors: [
  LoggingInterceptor(),
]);

const String base_url = 'http://192.168.15.90:8081/transactions';

Future<List<Transaction>> findAll() async {

  final Response response =
      // await client.get(Uri.parse('http://192.168.15.900:8081/transactions')).timeout(Duration(seconds: 7)); //erro direto
      // await client.get(Uri.parse('http://192.168.15.90:8081/transactions')).timeout(Duration(seconds: 7)); // erro timeout
      await client.get(Uri.parse(base_url)).timeout(Duration(seconds: 7));

  final List<dynamic> decodejson = jsonDecode(response.body);
  final List<Transaction> transactions = [];

  for (Map<String, dynamic> transactionJson in decodejson) {
    final Map<String, dynamic> contactJson = transactionJson['contact'];
    final Transaction transaction = Transaction(
      transactionJson['value'],
      Contact(0, contactJson['name'], contactJson['accountNumber']),
    );
    transactions.add(transaction);
  }

  return transactions;
}


Future<Transaction> save(Transaction transaction) async{

  final Map<String, dynamic> transactionMap = {
    'value': transaction.value,
    'contact': { 'name': transaction.contact.name, 'accountNumber': transaction.contact.accountNumber }
  };

  final String transactionJson = jsonEncode(transactionMap);

  final Response response = await client.post(Uri.parse(base_url),
    headers: {'content-type': 'application/json', 'password': '2000'},
    body:transactionJson
  );

  Map<String, dynamic> json =  jsonDecode(response.body);
  final Map<String, dynamic> contactJson = json['contact'];

  return Transaction(
    json['value'],
    Contact(0, contactJson['name'], contactJson['accountNumber']),
  );

}

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
