import 'package:flip_card/flip_card.dart';
import 'package:flip_card_game/flip_card_core.dart';
import 'package:flutter/material.dart';

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

  List<String> _randomImageNames = [];
  List<GlobalKey<FlipCardState>> _cardKeys = [];

  @override
  void initState() {
    super.initState();

    flipCardCore.reset();

    _randomImageNames = flipCardCore.randomImageNames;
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
            _randomImageNames.length,
            (index) {
              if (_randomImageNames[index].isEmpty) {
                return Container(
                  width: 100,
                  height: 150,
                  color: Colors.transparent,
                );
              }
              return FlipCard(
                key: _cardKeys[index],
                onFlip: () => flipCardCore.onFlip(index),
                onFlipDone: (bool) => flipCardCore.onFlipDone(setState),
                front: Container(
                  width: 100,
                  height: 150,
                  color: Colors.orange,
                ),
                back: Container(
                  width: 100,
                  height: 150,
                  child: Image.asset(
                    _randomImageNames[index],
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            flipCardCore.reset();
          });
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
