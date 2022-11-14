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

  List<String> _cards = [];
  final List<GlobalKey<FlipCardState>> _cardKeys = [];

  @override
  void initState() {
    super.initState();

    flipCardCore.stream.listen((event) {
      if (event is RewriteCardEvent) {
        _cardKeys.clear();
        _cardKeys.addAll(event.cards.map((_) => GlobalKey<FlipCardState>()));
        _cards = event.cards;
        setState(() {});
      }

      if (event is FlipToFrontCardEvent) {
        _toggleCardToFront(_cardKeys[event.toFlipCardIndexes[0]]);
        _toggleCardToFront(_cardKeys[event.toFlipCardIndexes[1]]);
      }
    });
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
      body: Center(
        child: Wrap(
          spacing: 4,
          runSpacing: 4,
          children: List.generate(
            _cards.length,
                (index) {
              if (_cards[index].isEmpty) {
                return Container(
                  width: 100,
                  height: 150,
                  color: Colors.transparent,
                );
              }
              return FlipCard(
                key: _cardKeys[index],
                speed: 2000,
                onFlipDone: (isFront) {
                  if (isFront) {
                    flipCardCore.unSelectCard(index);
                  } else {
                    flipCardCore.selectCard(index);
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
                    _cards[index],
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
          flipCardCore.reset();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }

  void _toggleAllCardToFront() {
    for (var cardKey in _cardKeys) {
      _toggleCardToFront(cardKey);
    }
  }

  void _toggleCardToFront(GlobalKey<FlipCardState> cardKey) {
    if (cardKey.currentState == null) {
      return;
    }

    if (!cardKey.currentState!.isFront) {
      cardKey.currentState!.toggleCard();
    }
  }
}
