import 'dart:async';

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
  final FlipCardCore flipCardCore = FlipCardCore();

  final List<GlobalKey<FlipCardState>> _cardKeys = [];

  @override
  void initState() {
    super.initState();

    reset();
  }

  void reset() {
    // add 2 times
    flipCardCore.reset();

    // create global key
    _cardKeys.clear();
    _cardKeys.addAll(flipCardCore.cards.map((_) => GlobalKey<FlipCardState>()));
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
            flipCardCore.cards.length,
            (index) {
              if (flipCardCore.cards[index].isEmpty) {
                return Container(
                  width: 100,
                  height: 150,
                  color: Colors.transparent,
                );
              }
              return FlipCard(
                key: _cardKeys[index],
                speed: 1000,
                onFlipDone: (isFront) {
                  if (isFront) {
                    flipCardCore.unSelectCard(index);
                  } else {
                    flipCardCore.selectCard(index);
                    if (flipCardCore.selectedCount == 2) {
                      if (flipCardCore.isEqual()) {
                        setState(() {});
                      } else {
                        _toggleCardToFront();
                      }
                    }
                  }
                },
                front: Container(
                  width: 100,
                  height: 150,
                  color: Colors.orange,
                ),
                back: SizedBox(
                  width: 100,
                  height: 150,
                  child: Image.asset(
                    flipCardCore.cards[index],
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
            reset();
          });
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }

  void _toggleCardToFront() {
    for (var cardKey in _cardKeys) {
      if (cardKey.currentState == null) continue;

      if (!cardKey.currentState!.isFront) {
        cardKey.currentState!.toggleCard();
      }
    }
  }
}
