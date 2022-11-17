import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

import 'flip_card_core.dart';
import 'gen/assets.gen.dart';
import 'model/card.dart';

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

  late final List<GlobalKey<FlipCardState>> _cardKeys;

  @override
  void initState() {
    super.initState();

    _cardKeys = List.generate(
        flipCardCore.length, (index) => GlobalKey<FlipCardState>());

    flipCardCore.flipFrontStream.listen((event) {
      for (var index in event) {
        _toggleCardToFront(_cardKeys[index]);
      }
    });
    flipCardCore.reset();
  }

  @override
  void dispose() {
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
            flipCardCore.length,
            (index) => StreamBuilder<ImageCard>(
                stream: flipCardCore.cardStreams[index],
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.requireData.name.isEmpty) {
                    return Container(
                      width: 100,
                      height: 150,
                      color: Colors.transparent,
                    );
                  }
                  return FlipCard(
                    key: _cardKeys[index],
                    onFlipDone: (isFront) {
                      flipCardCore.toggleCard(index, !isFront);
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
                        snapshot.requireData.name,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }),
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

  void _toggleCardToFront(GlobalKey<FlipCardState> cardKey) {
    if (cardKey.currentState == null) {
      return;
    }

    if (!cardKey.currentState!.isFront) {
      cardKey.currentState!.toggleCard();
    }
  }
}
