import 'package:flip_card/flip_card.dart';
import 'package:flip_card_game/asset_name.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp2());
}

class MyApp2 extends StatelessWidget {
  const MyApp2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage2(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage2 extends StatefulWidget {
  const MyHomePage2({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage2> createState() => _MyHomePage2State();
}

class _MyHomePage2State extends State<MyHomePage2> {
  final _imageNames = [
    AssetImageName.orange,
    AssetImageName.banana,
    AssetImageName.apple,
    AssetImageName.strawberry,
  ];

  final List<String> _randomImageNames = [];
  final List<GlobalKey<FlipCardState>> _cardKeys = [];
  int _frontCardCount = 0;
  final List<int> _frontCardIndexes = [];

  @override
  void initState() {
    super.initState();
    configureCards();
  }

  void configureCards() {
    _randomImageNames.addAll(_imageNames);
    _randomImageNames.addAll(_imageNames);
    _randomImageNames.shuffle();
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
          children: _buildCards(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _randomImageNames.shuffle();
            _toggleCardToFront();
          });
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }

  List<Widget> _buildCards() {
    return List.generate(
      _randomImageNames.length,
      (index) => _buildFlipCard(index),
    );
  }

  FlipCard _buildFlipCard(int index) {
    return FlipCard(
      key: _cardKeys[index],
      onFlip: () {
        _frontCardCount++;
        _frontCardIndexes.add(index);
      },
      onFlipDone: (isFront) {
        if (_frontCardCount == 2) {
          _toggleCardToFront();
          _checkCardIsEqual();
          _frontCardCount = 0;
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
          _randomImageNames[index],
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  void _toggleCardToFront() {
    for (var cardKey in _cardKeys) {
      final cardKeyState = cardKey.currentState;
      if (cardKeyState == null) return;
      if (!cardKeyState.isFront) {
        cardKeyState.toggleCard();
      }
    }
  }

  void _checkCardIsEqual() {
    if (_frontCardIndexes.length >= 2) {
      String firstCardName = _randomImageNames[_frontCardIndexes[0]];
      String secondCardName = _randomImageNames[_frontCardIndexes[1]];

      if (firstCardName == secondCardName) {
        _randomImageNames[_frontCardIndexes[0]] = '';
        _randomImageNames[_frontCardIndexes[1]] = '';

        setState(() {

        });
      }
    }

    _frontCardIndexes.clear();
    _frontCardCount = 0;
  }
}
