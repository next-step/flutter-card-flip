import 'package:flip_card/flip_card.dart';
import 'package:flip_card_game/flipcard/card_core.dart';
import 'package:flip_card_game/flipcard/card_state.dart';
import 'package:flip_card_game/model/cards.dart';
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
      theme: ThemeData(primarySwatch: Colors.blue),
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
  final CardCore _cardCore = CardCore();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    late Cards cards;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<CardState>(
        stream: _cardCore.stream,
        builder: (context, snapshot) {
          final state = snapshot.data;
          if (state == null) {
            return const SizedBox();
          }

          switch (state.runtimeType) {
            case InitialState:
            case CheckCardState:
              cards = state.cards;
              break;

            default:
              return const SizedBox();
          }

          return Center(
            child: Wrap(
              spacing: 4,
              runSpacing: 4,
              children: List.generate(
                cards.cardCount,
                (index) {
                  if (cards.isMatchedCard(index)) {
                    return Container(
                      width: 100,
                      height: 150,
                      color: Colors.transparent,
                    );
                  }
                  return FlipCard(
                    key: cards.getCardKey(index),
                    onFlip: () => _cardCore.flipFront(index),
                    onFlipDone: (isFont) => _cardCore.flipFrontDone(index),
                    front: Container(
                      width: 100,
                      height: 150,
                      color: Colors.orange,
                    ),
                    back: SizedBox(
                      width: 100,
                      height: 150,
                      child: Image.asset(
                        cards.getCardImage(index),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _cardCore.reset()),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
