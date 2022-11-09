import 'package:flip_card/flip_card.dart';
import 'package:flip_card_game/gen/assets.gen.dart';
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
  final _imageNames = Assets.images.values.map((e)=>e.path);

  final List<String> _randomImageNames = [];
  final List<GlobalKey<FlipCardState>> _cardKeys = [];
  int _frontCardCount = 0;
  final List<int> _frontCardIndexes = [];

  @override
  void initState() {
    super.initState();

    reset();
  }

  void reset() {
    // add 2 times
    _randomImageNames.clear();
    _randomImageNames.addAll(_imageNames);
    _randomImageNames.addAll(_imageNames);

    // shuffle
    _randomImageNames.shuffle();

    // create global key
    _cardKeys.clear();
    _cardKeys.addAll(_randomImageNames.map((_) => GlobalKey<FlipCardState>()));
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
            _randomImageNames.length,
            (index) {
              if (_randomImageNames[index].isEmpty) {
                return Container(
                  width: 100,
                  height: 150,
                  color: Colors.transparent,
                );
              }
              return FlipCard(
                key: _cardKeys[index],
                onFlip: () {
                  _frontCardCount++;
                  _frontCardIndexes.add(index);
                },
                onFlipDone: (bool) {
                  if (_frontCardCount == 2) {
                    _toggleCardToFront();

                    _checkCardIsEqual();

                    _frontCardCount = 0;

                    if (_frontCardIndexes.length >= 2) {
                      String firstCardName = _randomImageNames[_frontCardIndexes[0]];
                      String secondCardName = _randomImageNames[_frontCardIndexes[1]];
                      if (firstCardName == secondCardName) {
                        _randomImageNames[_frontCardIndexes[0]] = '';
                        _randomImageNames[_frontCardIndexes[1]] = '';

                        setState(() {});
                      }
                    }

                    _frontCardIndexes.clear();
                    _frontCardCount = 0;
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
                    _randomImageNames[index],
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
      if (cardKey.currentState == null) return;

      if (!cardKey.currentState!.isFront) {
        cardKey.currentState!.toggleCard();
      }
    }
  }

  void _checkCardIsEqual() {
    print('_checkCardIsEqual');
    print(_frontCardIndexes);
    if (_frontCardIndexes.length >= 2) {
      String firstCardName = _randomImageNames[_frontCardIndexes[0]];
      String secondCardName = _randomImageNames[_frontCardIndexes[1]];
      if (firstCardName == secondCardName) {
        _randomImageNames[_frontCardIndexes[0]] = '';
        _randomImageNames[_frontCardIndexes[1]] = '';

        setState(() {});
      }
    }

    _frontCardIndexes.clear();
  }
}
