import 'package:flip_card/flip_card.dart';
import 'package:flip_card_game/asset/asset_name.dart';
import 'package:flutter/material.dart';

class FlipCards {

  FlipCards();

  final _imageNames = [
    AssetImageName.orange,
    AssetImageName.banana,
    AssetImageName.apple,
    AssetImageName.strawberry,
  ];

  final List<String> _randomImageNames = [];
  final List<GlobalKey<FlipCardState>> _cardKeys = [];

  void reset() {
    _randomImageNames.clear();
    _randomImageNames.addAll(_imageNames);
    _randomImageNames.addAll(_imageNames);

    _randomImageNames.shuffle();

    _cardKeys.clear();
    _cardKeys.addAll(_randomImageNames.map((_) => GlobalKey<FlipCardState>()));
  }

  int getCardCount() {
    return _randomImageNames.length;
  }

  String getCardImage(int index) {
    return _randomImageNames[index];
  }

  void setCardImageEmpty(int index) {
    _randomImageNames[index] = '';
  }

  GlobalKey<FlipCardState> getCardKey(int index) {
    return _cardKeys[index];
  }

  bool isMatchedCard(int index) {
    return _randomImageNames[index].isEmpty;
  }

  void toggleCard() {
    for (var cardKey in _cardKeys) {
      if (cardKey.currentState == null) continue;

      if (!cardKey.currentState!.isFront) {
        cardKey.currentState!.toggleCard();
      }
    }
  }
}