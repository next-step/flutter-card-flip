import 'dart:async';

import 'package:flip_card_game/gen/assets.gen.dart';

class FlipCardCore {
  final _imageNames = Assets.images.values.map((e) => e.path);

  final StreamController<List<String>> _streamController = StreamController();
  Stream<List<String>> get stream => _streamController.stream;

  final List<String> _cards = [];

  final Set<int> _selectedCardIndexes = {};
  int get selectedCount=>_selectedCardIndexes.length;

  List<String> reset() {
    // reset selected states
    _selectedCardIndexes.clear();

    // add 2 times
    _cards.clear();
    _cards.addAll(_imageNames);
    _cards.addAll(_imageNames);

    // shuffle
    _cards.shuffle();
    _streamController.add(_cards);

    return _cards;
  }

  void selectCard(int idx) {
    _selectedCardIndexes.add(idx);
    print('selectCard index-${idx}');
    print(_selectedCardIndexes);
  }

  void unSelectCard(int idx) {
    _selectedCardIndexes.remove(idx);
    print('unSelectCard index-${idx}');
    print(_selectedCardIndexes);
  }

  bool isEqual() {
    print('_checkCardIsEqual');
    print(_selectedCardIndexes);

    if (_selectedCardIndexes.length >= 2) {
      int firstCardIdx = _pollSelectedCardIdx();
      String firstCardName = _cards[firstCardIdx];
      int secondCardIdx = _pollSelectedCardIdx();
      String secondCardName = _cards[secondCardIdx];
      if (firstCardName == secondCardName) {
        _cards[firstCardIdx] = '';
        _cards[secondCardIdx] = '';
        _streamController.add(_cards);
        return true;
      }
    }

    return false;
  }

  int _pollSelectedCardIdx() {
    int polledCardIdx = _selectedCardIndexes.first;
    _selectedCardIndexes.remove(polledCardIdx);
    return polledCardIdx;
  }

  void dispose(){
    _streamController.close();
  }
}
