import 'package:flip_card/flip_card.dart';
import 'package:flip_card_game/game_core.dart';
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
  final List<GlobalKey<FlipCardState>> _cardKeys = [];

  late FlipCardCore _core;

  List<String> _randomImageNames = [];

  @override
  void initState() {
    super.initState();

    _core = FlipCardCore();

    _core.stream.listen((event) {
      if (event is ResetState) {
        setState(() {
          _randomImageNames = event.randomImageNames;
          _cardKeys.addAll(_randomImageNames.map((e) => GlobalKey<FlipCardState>()));
          _toggleCardToFront();
        });
      }

      if (event is CheckCardState) {
        setState(() {
          _randomImageNames = event.randomImageNames;
          _toggleCardToFront();
        });
      }
    });

    _core.reset();
  }

  @override
  void dispose() {
    _core.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Wrap(
          spacing: 4,
          runSpacing: 4,
          children: List.generate(_randomImageNames.length, (index) {
            if (_randomImageNames[index].isEmpty) {
              return SizedBox(
                width: 100,
                height: 150,
              );
            }

            return FlipCard(
              key: _cardKeys[index],
              onFlipDone: (isFront) {
                if (isFront) return;

                _core.toggleCard(index);
              },
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
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          _core.reset();
        },
        child: const Icon(
          Icons.refresh,
        ),
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
