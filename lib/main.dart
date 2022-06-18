import 'package:bytebank/models/transaction.dart';
import 'package:bytebank/screens/contact_form.dart';
import 'package:bytebank/screens/contacts_list.dart';
import 'package:bytebank/screens/dashboard.dart';
import 'package:flutter/material.dart';

import 'database/app_database.dart';
import 'http/webclient.dart';
import 'models/contact.dart';

void main() {
  runApp(BytebankApp());
  // save(Contact(1, 'teste_named',1000)).then((id){
  //   save(Contact(0, 'Francinilda', 9000));
  //   // findAll().then((contacts) => debugPrint(contacts.toString()));
  // });

  // save(Transaction(300.0, Contact(0, 'jao', 3000 ))).then((value) => print(value));
  // findAll()
  //     .then((transaction) => print('new Transaction criada: $transaction'));

}

class BytebankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
            .copyWith(secondary: Colors.green),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blueAccent[700],
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: Dashboard(),
    );
  }
}
