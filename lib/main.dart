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
    _reset();
  }

  void _reset() {
    var cards = flipCardCore.reset();
    _cardKeys.clear();
    _cardKeys.addAll(cards.map((_) => GlobalKey<FlipCardState>()));
    _toggleAllCardToFront();
  }

  @override
  void dispose() {
    flipCardCore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<List<String>>(
        stream: flipCardCore.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox.shrink();
          }

          return Center(
            child: Wrap(
              spacing: 4,
              runSpacing: 4,
              children: List.generate(
                snapshot.requireData.length,
                (index) {
                  if (snapshot.requireData[index].isEmpty) {
                    return Container(
                      width: 100,
                      height: 150,
                      color: Colors.transparent,
                    );
                  }
                  return FlipCard(
                    key: _cardKeys[index],
                    onFlipDone: (isFront) {
                      if (isFront) {
                        flipCardCore.unSelectCard(index);
                      } else {
                        flipCardCore.selectCard(index);
                        if (flipCardCore.selectedCount == 2) {
                          if (!flipCardCore.isEqual()) {
                            _toggleAllCardToFront();
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
                        snapshot.requireData[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _reset();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }

  void _toggleAllCardToFront() {
    for (var cardKey in _cardKeys) {
      if (cardKey.currentState == null) continue;

      if (!cardKey.currentState!.isFront) {
        cardKey.currentState!.toggleCard();
      }
    }
  }
}
