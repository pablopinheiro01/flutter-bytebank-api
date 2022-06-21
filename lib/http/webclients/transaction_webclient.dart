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
    await client.get(Uri.parse(base_url)).timeout(Duration(seconds: 5));

    final List<dynamic> json = jsonDecode(response.body);

    return json.map((dynamic item) => Transaction.fromJson(item)).toList();
  }

  Future<Transaction> save(Transaction transaction) async{

    final Response response = await client.post(Uri.parse(base_url),
        headers: {'content-type': 'application/json', 'password': '2000'},
        body: jsonEncode(transaction.toJson())
    );
    return Transaction.fromJson(jsonDecode(response.body));
  }


}