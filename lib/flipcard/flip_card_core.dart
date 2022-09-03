import 'dart:async';

import 'package:flip_card/flip_card.dart';
import 'package:flip_card_game/asset/asset_name.dart';
import 'package:flutter/material.dart';

class FlipCardCore {
  FlipCardCore() {
    reset();
  }

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
  bool _isNoMatchedToggling = false;

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

  int getCardCount() {
    return _randomImageNames.length;
  }

  String getCardImage(int index) {
    return _randomImageNames[index];
  }

  GlobalKey<FlipCardState> getCardKey(int index) {
    return _cardKeys[index];
  }

  bool isMatchedCard(int index) {
    return _randomImageNames[index].isEmpty;
  }

  void flipFront(int index) {
    if (_isNoMatchedToggling) return;

    _frontCardCount++;
    _frontCardIndexes.add(index);
  }

  void flipFrontDone(int index, { required Function() onMatchedTwoCards }) {
    if (_isNoMatchedToggling) return;

    if (_frontCardCount == 2) {
      _checkCardIsEqual(onMatchedTwoCards);
      _toggleCardToFront();
    }
  }

  void _checkCardIsEqual(Function() onMatchedTwoCards) {
    if (_frontCardIndexes.length >= 2) {
      String firstCardName = _randomImageNames[_frontCardIndexes[0]];
      String secondCardName = _randomImageNames[_frontCardIndexes[1]];

      if (firstCardName == secondCardName) {
        _randomImageNames[_frontCardIndexes[0]] = '';
        _randomImageNames[_frontCardIndexes[1]] = '';

        onMatchedTwoCards();
      }
    }

    _frontCardIndexes.clear();
    _frontCardCount = 0;
  }

  void _toggleCardToFront() {
    _isNoMatchedToggling = true;

    for (var cardKey in _cardKeys) {
      if (cardKey.currentState == null) continue;

      if (!cardKey.currentState!.isFront) {
        cardKey.currentState!.toggleCard();
      }
    }

    Future.delayed(const Duration(microseconds: 150), () {
      _isNoMatchedToggling = false;
    });
  }
}