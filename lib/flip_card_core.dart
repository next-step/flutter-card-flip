import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flip_card_game/gen/assets.gen.dart';
import 'package:flip_card_game/util/debug_logger.dart';

abstract class FlipCardEvent {
  const FlipCardEvent();
}

class RewriteCardEvent extends FlipCardEvent {
  final List<String> cards;

  const RewriteCardEvent({required this.cards});
}

class FlipToFrontCardEvent extends FlipCardEvent {
  final List<int> toFlipCardIndexes;

  const FlipToFrontCardEvent({required this.toFlipCardIndexes});
}

class FlipCardCore extends Cubit<FlipCardEvent> {
  static final List<String> _imageNames =
      Assets.images.values.map((e) => e.path).toList();

  final Set<int> _selectedCardIndexes = {};

  int get selectedCount => _selectedCardIndexes.length;

  static final List<String> _cards = [];

  FlipCardCore() : super(_getInitCards());

  static RewriteCardEvent _getInitCards() {
    // add 2 times
    _cards.clear();
    _cards.addAll(_imageNames);
    _cards.addAll(_imageNames);

    // shuffle
    _cards.shuffle();
    return RewriteCardEvent(cards: _cards);
  }

  void reset() {
    // reset selected states
    _selectedCardIndexes.clear();

    emit(_getInitCards());
  }

  void selectCard(int idx) {
    _selectedCardIndexes.add(idx);
    debugPrint('selectCard index-${idx}');
    debugPrint(_selectedCardIndexes);
    _isEqual();
  }

  void unSelectCard(int idx) {
    _selectedCardIndexes.remove(idx);
    debugPrint('unSelectCard index-${idx}');
    debugPrint(_selectedCardIndexes);
  }

  void _isEqual() {
    debugPrint('_checkCardIsEqual');
    debugPrint(_selectedCardIndexes);

    if (_selectedCardIndexes.length >= 2) {
      int firstCardIdx = _pollSelectedCardIdx();
      String firstCardName = _cards[firstCardIdx];
      int secondCardIdx = _pollSelectedCardIdx();
      String secondCardName = _cards[secondCardIdx];
      if (firstCardName == secondCardName) {
        _cards[firstCardIdx] = '';
        _cards[secondCardIdx] = '';
        emit(RewriteCardEvent(cards: _cards));
      }
      emit(FlipToFrontCardEvent(
          toFlipCardIndexes: [firstCardIdx, secondCardIdx]));
    }
  }

  int _pollSelectedCardIdx() {
    int polledCardIdx = _selectedCardIndexes.first;
    _selectedCardIndexes.remove(polledCardIdx);
    return polledCardIdx;
  }
}
