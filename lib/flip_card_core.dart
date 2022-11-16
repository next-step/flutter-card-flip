import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

import 'gen/assets.gen.dart';

class FlipCardCore {
  final _imageNames = Assets.images.values.map((e) => e.path);

  final List<String> cardNames = [];
  final List<GlobalKey<FlipCardState>> cardKeys = [];

  int _flippedCardCount = 0;
  final List<int> _flippedCardIndexes = [];

  void reset() {
    cardNames.clear();
    cardNames.addAll(_imageNames);
    cardNames.addAll(_imageNames);
    cardNames.shuffle();

    cardKeys.clear();
    cardKeys.addAll(cardNames.map((_) => GlobalKey<FlipCardState>()));
  }

  void handleFlip(index) {
    _flippedCardCount++;
    _flippedCardIndexes.add(index);
  }

  void handleFlipDone(setState) {
    if (_flippedCardCount == 2) {
      _toggleCardToFront();
      _checkCardIsEqual(setState);

      _flippedCardCount = 0;
    }
  }

  void _toggleCardToFront() {
    for (var cardKey in cardKeys) {
      if (cardKey.currentState == null) return;

      if (!cardKey.currentState!.isFront) {
        cardKey.currentState!.toggleCard();
      }
    }
  }

  void _checkCardIsEqual(setState) {
    if (_flippedCardIndexes.length >= 2) {
      String firstCardName = cardNames[_flippedCardIndexes[0]];
      String secondCardName = cardNames[_flippedCardIndexes[1]];

      if (firstCardName == secondCardName) {
        cardNames[_flippedCardIndexes[0]] = '';
        cardNames[_flippedCardIndexes[1]] = '';

        setState(() {});
      }
    }

    _flippedCardIndexes.clear();
  }
}
