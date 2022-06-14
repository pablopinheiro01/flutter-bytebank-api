import 'package:bytebank/screens/contacts_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image.network('https://cdn.pixabay.com/photo/2022/05/28/13/02/plant-7227222_960_720.jpg')
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('images/bytebank.png'),
          ),
          Row(
            children: [
              _FeatureItem('Transfer', Icons.monetization_on),
              _FeatureItem('Transection Feed', Icons.description),
            ],
          ),


        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {

  final String name;
  final IconData icon;

  _FeatureItem(this.name, this.icon);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      // child: GestureDetector(
      child: Material(
        color: Colors.green,
        child: InkWell(// componente do material
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ContactsList()));
          },
          child: Container(
            padding: EdgeInsets.all(8.0),
            height: 140,
            width: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: Colors.white, size: 56,),
                Text(name,
                  style: TextStyle(color:Colors.white, fontSize: 16.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }
}

