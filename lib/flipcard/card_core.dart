import 'dart:async';

import 'package:flip_card_game/flipcard/card_state.dart';
import 'package:flip_card_game/model/cards.dart';

class CardCore {
  CardCore() {
    reset();
  }

  final Cards _cards = Cards();

  int _frontCardCount = 0;
  final List<int> _frontCardIndexes = [];
  bool _isNoMatchedToggling = false;

  final StreamController<CardState> _streamController = StreamController();
  Stream<CardState>? get stream => _streamController.stream;

  void reset() {
    _cards.reset();
    _streamController.add(InitialState(_cards));
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
      String firstCardName = _cards.getCardImage(_frontCardIndexes[0]);
      String secondCardName = _cards.getCardImage(_frontCardIndexes[1]);

      if (firstCardName == secondCardName) {
        _cards.setCardImageEmpty(_frontCardIndexes[0]);
        _cards.setCardImageEmpty(_frontCardIndexes[1]);

        _streamController.add(CheckCardState(_cards));
      }
    }

    _frontCardIndexes.clear();
    _frontCardCount = 0;
  }

  void _toggleCardToFront() {
    _isNoMatchedToggling = true;

    _cards.toggleCard();

    Future.delayed(const Duration(microseconds: 150), () {
      _isNoMatchedToggling = false;
    });
  }
}