import 'package:bytebank/components/centered_message.dart';
import 'package:bytebank/components/progress.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/screens/contact_form.dart';
import 'package:bytebank/screens/transaction_form.dart';
import 'package:flutter/material.dart';

import '../database/dao/ContactDAO.dart';

class ContactsList extends StatefulWidget {
  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  final ContactDAO dao = ContactDAO();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Transfer')),
      body: FutureBuilder<List<Contact>>(
        // initialData: [], //insere um valor inicial
        future: Future.delayed(Duration(
                seconds:
                    1)) //seta um delay na busca para simular uma chamada async
            .then((value) => dao.findAll()), //busca todos os contatos
        builder: (context, snapshot) {
          //quando tiver a resposta modifica o builder
          switch (snapshot.connectionState) {
            case ConnectionState.none: //future ainda nao foi executado
              break;
            case ConnectionState
                .waiting: //verifica que o future ainda esta carregando
              Progress();
              break;
            case ConnectionState.active:
              //significa que tem dado disponivel mas ainda nao foi finalizado o future
              //usado por exemplo em download, mostrando o progresso continuo
              break;
            case ConnectionState.done:
              if (snapshot.hasData) {
                final List<Contact> contacts = snapshot.data as List<Contact>;
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return _ContactItem(contacts[index], onClick: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => TransactionForm(contacts[index])));
                    },);
                  },
                  itemCount: contacts.length,
                );
              }
              CenteredMessage('Empty data', icon: Icons.error_rounded,);

              break;
          }
          return CenteredMessage('Unknown error database'); //provavelmente nunca caira nesse bloco
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (context) => ContactForm(),
                ),
              )
              .then((value) => setState(() {}));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final Contact contact;
  final Function onClick;

  _ContactItem(this.contact, { required this.onClick });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          contact.name,
          style: TextStyle(fontSize: 24),
        ),
        subtitle: Text(contact.accountNumber.toString()),
        onTap: () {
          // Navigator.of(context).push(MaterialPageRoute(
          //   builder: (context) => ContactForm(),
          // ));
          onClick();
        },
      ),
    );
  }
}
