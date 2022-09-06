import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

import 'asset_name.dart';

class FlipCardCore {
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

  List<String> get randomImageNames => _randomImageNames;
  List<GlobalKey<FlipCardState>> get cardKeys => _cardKeys;

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

  void _checkCardIsEqual(setState) {
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

  void _toggleCardToFront() {
    for (var cardKey in _cardKeys) {
      if (cardKey.currentState == null) return;

      if (!cardKey.currentState!.isFront) {
        cardKey.currentState!.toggleCard();
      }
    }
  }

  void onFlip(index) {
    _frontCardCount++;
    _frontCardIndexes.add(index);
  }

  void onFlipDone(setState) {
    if (_frontCardCount == 2) {
      _toggleCardToFront();

      _checkCardIsEqual(setState);

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
  }
}
