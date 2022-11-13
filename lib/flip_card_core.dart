import 'package:flip_card_game/gen/assets.gen.dart';

class FlipCardCore {
  final _imageNames = Assets.images.values.map((e) => e.path);

  final List<String> cards = [];

  final Set<int> _selectedCardIndexes = {};
  int get selectedCount=>_selectedCardIndexes.length;

  void reset() {
    // add 2 times
    cards.clear();
    cards.addAll(_imageNames);
    cards.addAll(_imageNames);

    // shuffle
    cards.shuffle();
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
      String firstCardName = cards[firstCardIdx];
      int secondCardIdx = _pollSelectedCardIdx();
      String secondCardName = cards[secondCardIdx];
      if (firstCardName == secondCardName) {
        cards[firstCardIdx] = '';
        cards[secondCardIdx] = '';
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
}
