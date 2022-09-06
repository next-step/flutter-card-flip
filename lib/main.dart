import 'package:flip_card/flip_card.dart';
import 'package:flip_card_game/flipcard/card_core.dart';
import 'package:flip_card_game/flipcard/card_event.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<CardState>(
          stream: _cardCore.stream,
          builder: (context, snapshot) {
            final state = snapshot.data;
            if (state == null) {
              _cardCore.add(ResetEvent());
              return const SizedBox();
            }

            if (state is ResetCardState) {
              return _buildCards(state.cards);
            }

            if (state is CheckCardState) {
              return _buildCards(state.cards);
            }

            return const SizedBox();
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _cardCore.add(ResetEvent()),
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Center _buildCards(Cards cards) {
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
              onFlip: () => _cardCore.add(FlippingEvent(index)),
              onFlipDone: (isFont) => _cardCore.add(FlipDoneEvent(index)),
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
}
