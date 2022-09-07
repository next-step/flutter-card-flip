import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flip_card_game/flipcard/card_event.dart';
import 'package:flip_card_game/flipcard/card_state.dart';
import 'package:flip_card_game/model/cards.dart';

class CardCore extends Bloc<CardEvent, CardState> {
  CardCore() : super(InitialState()) {
    on<InitialEvent>(_onInitialEvent);
    on<ResetEvent>(_onResetEvent);
    on<FlippingEvent>(_onFlippingEvent);
    on<FlipDoneEvent>(_onFlipDoneEvent);
  }

  final Cards _cards = Cards();

  int _frontCardCount = 0;
  final List<int> _frontCardIndexes = [];
  bool _isNoMatchedToggling = false;

  void _onInitialEvent(InitialEvent event, Emitter emit) {
    _resetCard(emit);
  }

  void _onResetEvent(ResetEvent event, Emitter emit) {
    _resetCard(emit);
  }

  void _resetCard(Emitter emit) {
    _cards.reset();
    emit(ResetCardState(_cards));
  }

  void _onFlippingEvent(FlippingEvent event, Emitter emit) {
    if (_isNoMatchedToggling) return;

    _frontCardCount++;
    _frontCardIndexes.add(event.index);
  }

  void _onFlipDoneEvent(FlipDoneEvent event, Emitter emit) {
    if (_isNoMatchedToggling) return;

    if (_frontCardCount == 2) {
      _checkCardIsEqual(emit);
      _toggleCardToFront();
    }
  }

  void _checkCardIsEqual(Emitter emit) {
    if (_frontCardIndexes.length >= 2) {
      String firstCardName = _cards.getCardImage(_frontCardIndexes[0]);
      String secondCardName = _cards.getCardImage(_frontCardIndexes[1]);

      if (firstCardName == secondCardName) {
        _cards.setCardImageEmpty(_frontCardIndexes[0]);
        _cards.setCardImageEmpty(_frontCardIndexes[1]);

        emit(CheckCardState(_cards));
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
