import 'package:bytebank/components/centered_message.dart';
import 'package:bytebank/http/webclient.dart';
import 'package:bytebank/http/webclients/transaction_webclient.dart';
import 'package:flutter/material.dart';

import '../components/progress.dart';
import '../models/contact.dart';
import '../models/transaction.dart';

class TransactionsList extends StatelessWidget {

  final TransactionWebClient _webClient = TransactionWebClient();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Transactions'),
        ),
        body: FutureBuilder<List<Transaction>>(
            future: Future.delayed(Duration(seconds: 1)).then((value) => _webClient.findAll()),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  break;
                case ConnectionState.waiting:
                  return Progress();
                case ConnectionState.active:
                  break;
                case ConnectionState.done:
                  if(snapshot.hasData){
                    final List<Transaction>? transactions = snapshot.data;
                    return ListView.builder(itemBuilder: (context, index) {
                      final Transaction transaction = transactions![index];
                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.monetization_on),
                          title: Text(
                            transaction.value.toString(),
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            transaction.contact.accountNumber.toString(),
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      );
                    }, itemCount: transactions!.length,);
                  }
                  return CenteredMessage('No transactions found', icon: Icons.warning,);
              }
              return CenteredMessage('Unknow error');
            }));
  }
}
