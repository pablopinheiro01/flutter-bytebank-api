
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TransactionAuthDialog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Authenticate'),
      content: TextField(
        obscureText: true,
        maxLength: 4,
        decoration: InputDecoration(
          border: OutlineInputBorder()
        ),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: TextStyle(
          fontSize: 64,
          letterSpacing: 32
        ),
      ),
      actions: [
        TextButton(
            onPressed: (){ debugPrint("clicado cancelamento");},
            child: Text('Cancel')
        ),
        TextButton(
            onPressed: (){ debugPrint("clicado em confirmar");},
            child: Text('Confirm')
        )
      ],
    );
  }
}
