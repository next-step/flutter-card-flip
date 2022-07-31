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

  final FlipCardCore _core = FlipCardCore();

  @override
  void initState() {
    super.initState();

    _reset();
  }

  @override
  void dispose() {
    _core.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: StreamBuilder<List<String>>(
            stream: _core.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return SizedBox.shrink();
              }

              return Wrap(
                spacing: 4,
                runSpacing: 4,
                children: List.generate(snapshot.requireData.length, (index) {
                  if (snapshot.requireData[index].isEmpty) {
                    return Container(
                      width: 100,
                      height: 150,
                    );
                  }

                  return FlipCard(
                    key: _cardKeys[index],
                    onFlipDone: (isFront) {
                      if (isFront) return;

                      _core.toggleCard(index);

                      if (_core.backCardLength >= 2) {
                        _toggleCardToFront();
                        _core.checkCardIsEqual();
                      }
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
                        snapshot.requireData[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _reset();
          });
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }

  void _reset() {
    final randomImageNames = _core.reset();
    _cardKeys.addAll(randomImageNames.map((e) => GlobalKey<FlipCardState>()));
    _toggleCardToFront();
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
