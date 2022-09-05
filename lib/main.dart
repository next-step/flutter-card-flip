import 'package:flip_card/flip_card.dart';
import 'package:flip_card_game/flipcard/flip_card_core.dart';
import 'package:flip_card_game/model/flip_cards.dart';
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
  final FlipCardCore _flipCardCore = FlipCardCore();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<FlipCards>(
        stream: _flipCardCore.streamController.stream,
        builder: (context, snapshot) {
          final flipCards = snapshot.data;
          if (flipCards == null) {
            return const SizedBox();
          }

          return Center(
            child: Wrap(
              spacing: 4,
              runSpacing: 4,
              children: List.generate(
                flipCards.cardCount,
                (index) {
                  if (flipCards.isMatchedCard(index)) {
                    return Container(
                      width: 100,
                      height: 150,
                      color: Colors.transparent,
                    );
                  }
                  return FlipCard(
                    key: flipCards.getCardKey(index),
                    onFlip: () => _flipCardCore.flipFront(index),
                    onFlipDone: (isFont) => _flipCardCore.flipFrontDone(index),
                    front: Container(
                      width: 100,
                      height: 150,
                      color: Colors.orange,
                    ),
                    back: SizedBox(
                      width: 100,
                      height: 150,
                      child: Image.asset(
                        flipCards.getCardImage(index),
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
        onPressed: () => setState(() => _flipCardCore.reset()),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
