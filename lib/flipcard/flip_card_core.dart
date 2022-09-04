import 'dart:async';

import 'package:flip_card_game/model/flip_cards.dart';

class FlipCardCore {
  FlipCardCore() {
    reset();
  }

  final FlipCards _flipCards = FlipCards();

  int _frontCardCount = 0;
  final List<int> _frontCardIndexes = [];
  bool _isNoMatchedToggling = false;

  final StreamController<FlipCards> streamController = StreamController();

  void reset() {
    _flipCards.reset();
    streamController.add(_flipCards);
  }

  void flipFront(int index) {
    if (_isNoMatchedToggling) return;

    _frontCardCount++;
    _frontCardIndexes.add(index);
  }

  void flipFrontDone(int index) {
    if (_isNoMatchedToggling) return;

    if (_frontCardCount == 2) {
      _checkCardIsEqual();
      _toggleCardToFront();
    }
  }

  void _checkCardIsEqual() {
    if (_frontCardIndexes.length >= 2) {
      String firstCardName = _flipCards.getCardImage(_frontCardIndexes[0]);
      String secondCardName = _flipCards.getCardImage(_frontCardIndexes[1]);

      if (firstCardName == secondCardName) {
        _flipCards.setCardImageEmpty(_frontCardIndexes[0]);
        _flipCards.setCardImageEmpty(_frontCardIndexes[1]);

        streamController.add(_flipCards);
      }
    }

    _frontCardIndexes.clear();
    _frontCardCount = 0;
  }

  void _toggleCardToFront() {
    _isNoMatchedToggling = true;

    _flipCards.toggleCard();

    Future.delayed(const Duration(microseconds: 150), () {
      _isNoMatchedToggling = false;
    });
  }
}