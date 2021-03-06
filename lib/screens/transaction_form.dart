import 'dart:async';

import 'package:bytebank/components/transaction_auth_dialog.dart';
import 'package:bytebank/http/webclients/transaction_webclient.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../components/progress.dart';
import '../components/response_dialog.dart';
import '../models/contact.dart';
import '../models/transaction.dart';

class TransactionForm extends StatefulWidget {
  final Contact contact;

  TransactionForm(this.contact);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController _valueController = TextEditingController();
  final TransactionWebClient _webClient = TransactionWebClient();
  final String transactionId = Uuid().v4();

  bool _sending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New transaction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Visibility(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Progress(message: "Sending...",),
                  ),
                visible: _sending,
              ),
              Text(
                widget.contact.name,
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  widget.contact.accountNumber.toString(),
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _valueController,
                  style: TextStyle(fontSize: 24.0),
                  decoration: InputDecoration(labelText: 'Value'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    child: Text('Transfer'),
                    onPressed: () {
                      final double? value =
                          double.tryParse(_valueController.text);
                      final transactionCreated =
                          Transaction(transactionId, value!, widget.contact);
                      showDialog(
                          context: context,
                          builder: (contextDialog) { //enviando o contexto do builder diferente do context geral
                            return TransactionAuthDialog(
                                onConfirm: (String password) {
                              _save(transactionCreated, password, context);
                            });
                          });
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _save(Transaction transactionCreated, String password, BuildContext context) async {
    // await Future.delayed(Duration(seconds: 1)); //setado um delay para requisi??ao

    setState((){
      _sending = true;
    });

    Transaction transaction = await _send(transactionCreated, password, context);

    await _showSuccessFulMessage(transaction, context);
  }

  Future<Transaction> _send(Transaction transactionCreated, String password, BuildContext context) async {
    final Transaction transaction = await _webClient.save(transactionCreated, password)
        .catchError((e){
        _showFailureMessage(context, "Timeout submitting the transaction");
      },
    test: (e) => e is TimeoutException)
        .catchError((error){
        _showFailureMessage(context, error.message);
      },
      test: (error) => error is HttpException //garantimos a impl default tem um message
      ).whenComplete(() => setState(() => _sending = false)); // finalizando a request eu removo o progress
    return transaction;
  }

  void _showFailureMessage(BuildContext context, String message) {
    showDialog(context: context, builder: (contextDialog){
      return FailureDialog(message);
    });
  }

  Future<void> _showSuccessFulMessage(Transaction transaction, BuildContext context) async {
    if (transaction != null) {
      await showDialog(context: context, builder: (contextDialog){
        return SuccessDialog("Successful transaction");
      });
      Navigator.pop(context);
    }
  }

}
