import 'package:flip_card/flip_card.dart';
import 'package:flip_card_game/asset_name.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp2());
}

class MyApp2 extends StatelessWidget {
  const MyApp2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage2(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage2 extends StatefulWidget {
  const MyHomePage2({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage2> createState() => _MyHomePage2State();
}

class _MyHomePage2State extends State<MyHomePage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Wrap(
          spacing: 4,
          runSpacing: 4,
          children: <Widget>[
            FlipCard(
              front: Container(
                width: 100,
                height: 150,
                color: Colors.orange,
              ),
              back: SizedBox(
                width: 100,
                height: 150,
                child: Image.asset(AssetImageName.banana),
              ),
            ),
            FlipCard(
              front: Container(
                width: 100,
                height: 150,
                color: Colors.orange,
              ),
              back: SizedBox(
                width: 100,
                height: 150,
                child: Image.asset(AssetImageName.banana),
              ),
            ),
            FlipCard(
              front: Container(
                width: 100,
                height: 150,
                color: Colors.orange,
              ),
              back: SizedBox(
                width: 100,
                height: 150,
                child: Image.asset(AssetImageName.banana),
              ),
            ),
            FlipCard(
              front: Container(
                width: 100,
                height: 150,
                color: Colors.orange,
              ),
              back: SizedBox(
                width: 100,
                height: 150,
                child: Image.asset(AssetImageName.banana),
              ),
            ),
            FlipCard(
              front: Container(
                width: 100,
                height: 150,
                color: Colors.orange,
              ),
              back: SizedBox(
                width: 100,
                height: 150,
                child: Image.asset(AssetImageName.banana),
              ),
            ),
            FlipCard(
              front: Container(
                width: 100,
                height: 150,
                color: Colors.orange,
              ),
              back: SizedBox(
                width: 100,
                height: 150,
                child: Image.asset(AssetImageName.banana),
              ),
            ),
            FlipCard(
              front: Container(
                width: 100,
                height: 150,
                color: Colors.orange,
              ),
              back: SizedBox(
                width: 100,
                height: 150,
                child: Image.asset(AssetImageName.banana),
              ),
            ),
            FlipCard(
              front: Container(
                width: 100,
                height: 150,
                color: Colors.orange,
              ),
              back: SizedBox(
                width: 100,
                height: 150,
                child: Image.asset(AssetImageName.banana),
              ),
            ),
          ]
        ),
      ),
    );
  }
}

