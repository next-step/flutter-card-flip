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

    _cards = flipCardCore.state;
    _cardKeys.clear();
    _cardKeys.addAll(flipCardCore.state.map((_) => GlobalKey<FlipCardState>()));

    flipCardCore.stream.listen((event) {
      _cards = event;
      _cardKeys.forEach(_toggleCardToFront);
      setState(() {});
    });
  }

  @override
  void dispose() {
    flipCardCore.close();
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
                onFlipDone: (isFront) {
                  flipCardCore.add(SelectCardEvent(
                    toFlipCardIndex: index,
                    isSelect: !isFront,
                  ));
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
          flipCardCore.add(RewriteCardEvent());
        },
        child: const Icon(Icons.refresh),
      ),
    );
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
