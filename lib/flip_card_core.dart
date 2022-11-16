import 'dart:async';

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

class FlipCardCore {
  final _imageNames = Assets.images.values.map((e) => e.path);

  final StreamController<FlipCardEvent> _streamController = StreamController();

  Stream<FlipCardEvent> get stream => _streamController.stream;

  final List<String> _cards = [];

  final Set<int> _selectedCardIndexes = {};

  int get selectedCount => _selectedCardIndexes.length;

  void reset() {
    // reset selected states
    _selectedCardIndexes.clear();

    // add 2 times
    _cards.clear();
    _cards.addAll(_imageNames);
    _cards.addAll(_imageNames);

    // shuffle
    _cards.shuffle();
    _streamController.add(RewriteCardEvent(cards: _cards));
  }

  void selectCard(int idx) {
    _assertIndex(idx);
    _selectedCardIndexes.add(idx);
    debugPrint('selectCard index-$idx');
    debugPrint(_selectedCardIndexes);
    _checkSelectedCards();
  }

  void unSelectCard(int idx) {
    _assertIndex(idx);
    _selectedCardIndexes.remove(idx);
    debugPrint('unSelectCard index-$idx');
    debugPrint(_selectedCardIndexes);
  }

  void _assertIndex(int idx) {
    if (idx < 0 || _cards.length <= idx) {
      debugPrint('select index is out of range!! idx=$idx');
      throw ArgumentError('index out of range');
    }
  }

  void _checkSelectedCards() {
    debugPrint('_checkCardIsEqual');
    debugPrint(_selectedCardIndexes);

    if (_selectedCardIndexes.length < 2) {
      return;
    }

    final int firstCardIdx = _pollSelectedCardIdx();
    final String firstCardName = _cards[firstCardIdx];
    final int secondCardIdx = _pollSelectedCardIdx();
    final String secondCardName = _cards[secondCardIdx];
    if (firstCardName == secondCardName) {
      _cards[firstCardIdx] = '';
      _cards[secondCardIdx] = '';
      _streamController.add(RewriteCardEvent(cards: _cards));
    }
    _streamController.add(
        FlipToFrontCardEvent(toFlipCardIndexes: [firstCardIdx, secondCardIdx]));
  }

  int _pollSelectedCardIdx() {
    try {
      final int polledCardIdx = _selectedCardIndexes.first;
      _selectedCardIndexes.remove(polledCardIdx);
      return polledCardIdx;
    } on StateError catch (e) {
      debugPrint('_selectedCardIndexes is Empty!!');
      rethrow;
    }
  }

  void dispose() {
    _streamController.close();
  }
}
