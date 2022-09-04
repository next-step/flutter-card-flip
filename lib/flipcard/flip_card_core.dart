import 'dart:async';

import 'package:flip_card/flip_card.dart';
import 'package:flip_card_game/model/flip_cards.dart';
import 'package:flutter/material.dart';

class FlipCardCore {
  FlipCardCore() {
    reset();
  }

  final FlipCards _flipCards = FlipCards();

  int _frontCardCount = 0;
  final List<int> _frontCardIndexes = [];
  bool _isNoMatchedToggling = false;

  void reset() {
    _flipCards.reset();
  }

  int getCardCount() {
    return _flipCards.getCardCount();
  }

  String getCardImage(int index) {
    return _flipCards.getCardImage(index);
  }

  GlobalKey<FlipCardState> getCardKey(int index) {
    return _flipCards.getCardKey(index);
  }

  bool isMatchedCard(int index) {
    return _flipCards.isMatchedCard(index);
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
      String firstCardName = _flipCards.getCardImage(_frontCardIndexes[0]);
      String secondCardName = _flipCards.getCardImage(_frontCardIndexes[1]);

      if (firstCardName == secondCardName) {
        _flipCards.setCardImageEmpty(_frontCardIndexes[0]);
        _flipCards.setCardImageEmpty(_frontCardIndexes[1]);

        onMatchedTwoCards();
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