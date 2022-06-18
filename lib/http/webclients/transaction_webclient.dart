import 'dart:convert';

import 'package:http/http.dart';

import '../../models/contact.dart';
import '../../models/transaction.dart';
import '../webclient.dart';

class TransactionWebClient{

  Future<List<Transaction>> findAll() async {

    final Response response =
    // await client.get(Uri.parse('http://192.168.15.900:8081/transactions')).timeout(Duration(seconds: 7)); //erro direto
    // await client.get(Uri.parse('http://192.168.15.90:8081/transactions')).timeout(Duration(seconds: 7)); // erro timeout
    await client.get(Uri.parse(base_url)).timeout(Duration(seconds: 7));

    List<Transaction> transactions = _toTransactions(response);

    return transactions;
  }

  List<Transaction> _toTransactions(Response response) {
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

    Map<String, dynamic> transactionMap = toMap(transaction);
    final String transactionJson = jsonEncode(transactionMap);

    final Response response = await client.post(Uri.parse(base_url),
        headers: {'content-type': 'application/json', 'password': '2000'},
        body:transactionJson
    );

    return toTransaction(response);

  }

  Transaction toTransaction(Response response) {
    Map<String, dynamic> json =  jsonDecode(response.body);
    final Map<String, dynamic> contactJson = json['contact'];

    return Transaction(
      json['value'],
      Contact(0, contactJson['name'], contactJson['accountNumber']),
    );
  }

  Map<String, dynamic> toMap(Transaction transaction) {
       final Map<String, dynamic> transactionMap = {
      'value': transaction.value,
      'contact': { 'name': transaction.contact.name, 'accountNumber': transaction.contact.accountNumber }
    };
    return transactionMap;
  }

}