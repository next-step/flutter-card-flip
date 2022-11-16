import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

import 'flip_card_core.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final flipCardCore = FlipCardCore();

  List<String> _cardNames = [];
  List<GlobalKey<FlipCardState>> _cardKeys = [];

  @override
  void initState() {
    super.initState();

    flipCardCore.reset();

    _cardNames = flipCardCore.cardNames;
    _cardKeys = flipCardCore.cardKeys;
  }

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
          children: List.generate(
            _cardNames.length,
            (index) {
              if (_cardNames[index].isEmpty) {
                return Container(
                  width: 100,
                  height: 150,
                  color: Colors.transparent,
                );
              }

              return FlipCard(
                key: _cardKeys[index],
                onFlip: () => flipCardCore.handleFlip(index),
                onFlipDone: (bool) => flipCardCore.handleFlipDone(setState),
                front: Container(
                  width: 100,
                  height: 150,
                  color: Colors.orange,
                ),
                back: SizedBox(
                  width: 100,
                  height: 150,
                  child: Image.asset(
                    _cardNames[index],
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        onPressed: () {
          setState(() {
            flipCardCore.reset();
          });
        },
      ),
    );
  }
}
