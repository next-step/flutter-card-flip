import 'dart:async';

import 'package:flip_card_game/asset_name.dart';

class FlipCardCore {
  final _imageNames = [
    AssetImageName.orange,
    AssetImageName.banana,
    AssetImageName.apple,
    AssetImageName.strawberry,
  ];

  final List<int> _backCardIndexes = [];
  int get backCardLength => _backCardIndexes.length;

  final List<String> _randomImageNames = [];

  Stream<List<String>> get stream => _streamController.stream;

  final StreamController<List<String>> _streamController = StreamController();

  List<String> reset() {
    // add 2 times
    _randomImageNames.clear();
    _randomImageNames.addAll(_imageNames);
    _randomImageNames.addAll(_imageNames);

    // shuffle
    _randomImageNames.shuffle();

    _streamController.add(_randomImageNames);

    return _randomImageNames;
  }

  void toggleCard(int index) {
    _backCardIndexes.add(index);
  }

  void checkCardIsEqual() {
    if (_backCardIndexes.length < 2) return;

    String firstCardName = _randomImageNames[_backCardIndexes[0]];
    String secondCardName = _randomImageNames[_backCardIndexes[1]];
    if (firstCardName == secondCardName) {
      _randomImageNames[_backCardIndexes[0]] = '';
      _randomImageNames[_backCardIndexes[1]] = '';
    }

    _backCardIndexes.clear();

    _streamController.add(_randomImageNames);
  }

  void dispose() {
    _streamController.close();
  }
}