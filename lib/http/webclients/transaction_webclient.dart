import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../../models/transaction.dart';
import '../webclient.dart';

class TransactionWebClient{

  Future<List<Transaction>> findAll() async {

    final Response response =
    // await client.get(Uri.parse('http://192.168.15.900:8081/transactions')).timeout(Duration(seconds: 7)); //erro direto
    // await client.get(Uri.parse('http://192.168.15.90:8081/transactions')).timeout(Duration(seconds: 7)); // erro timeout
    await client.get(Uri.parse(base_url));

    final List<dynamic> json = jsonDecode(response.body);

    return json.map((dynamic item) => Transaction.fromJson(item)).toList();
  }

  Future<Transaction> save(Transaction transaction, String password) async{

    await Future.delayed(Duration(seconds: 10));

    final Response response = await client.post(Uri.parse(base_url),
        headers: {'content-type': 'application/json', 'password': password},
        body: jsonEncode(transaction.toJson())
    );

    if(response.statusCode != 200) {
      throw HttpException(_getMessage(response.statusCode)!);
    }

    return Transaction.fromJson(jsonDecode(response.body));

    }

  static final Map<int, String> _statusCodeResponse = {
    400:"There was an error submitting transaction",
    401: "Authentication Failed",
    409: "transaction already existss"
  };

  String? _getMessage(int statusCode) {
    if(_statusCodeResponse.containsKey(statusCode)){
      debugPrint("erro pego ${_statusCodeResponse[statusCode]} ");
      return _statusCodeResponse[statusCode];
    }else{
      debugPrint("nao pegou o erro ${statusCode}");
    }
    return 'Unknow error';
  }

}

class HttpException implements Exception{
  final String message;

  HttpException(this.message);
}