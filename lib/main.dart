import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Гриценко Ева Анатольевна'),
        ),
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.star, size: 40, color: Colors.amber),
              Icon(Icons.favorite, size: 40, color: Colors.red),
              Icon(Icons.home, size: 40, color: Colors.blue),
            ],
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.phone, size: 40, color: Colors.green),
              Icon(Icons.email, size: 40, color: Colors.deepOrange),
              Icon(Icons.settings, size: 40, color: Colors.grey),
            ],
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.camera_alt, size: 40, color: Colors.purple),
              Icon(Icons.music_note, size: 40, color: Colors.teal),
              Icon(Icons.shopping_cart, size: 40, color: Colors.brown),
            ],
          ),
        ],
      ),
    );
  }
}