import 'package:bloc/bloc.dart';
import 'package:flip_card_game/gen/assets.gen.dart';
import 'package:flip_card_game/util/debug_logger.dart';

class FlipCardCore extends Cubit<List<String>> {
  static final List<String> _imageNames =
      Assets.images.values.map((e) => e.path).toList();

  final Set<int> _selectedCardIndexes = {};

  int get selectedCount => _selectedCardIndexes.length;

  FlipCardCore() : super(_getInitCards());

  static List<String> _getInitCards() {
    // add 2 times
    List<String> _cards = [];
    _cards.clear();
    _cards.addAll(_imageNames);
    _cards.addAll(_imageNames);

    // shuffle
    _cards.shuffle();
    return _cards;
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
    debugPrint('unSelectCard index-$idx');
    debugPrint(_selectedCardIndexes);
  }

  void _isEqual() {
    debugPrint('_checkCardIsEqual');
    debugPrint(_selectedCardIndexes);

    if (_selectedCardIndexes.length >= 2) {
      int firstCardIdx = _pollSelectedCardIdx();
      String firstCardName = state[firstCardIdx];
      int secondCardIdx = _pollSelectedCardIdx();
      String secondCardName = state[secondCardIdx];
      List<String> cards = [];
      if (firstCardName == secondCardName) {
        state[firstCardIdx] = '';
        state[secondCardIdx] = '';
        debugPrint('correct!');
      }
      cards.addAll(state);
      emit(cards);
    }
  }

  int _pollSelectedCardIdx() {
    int polledCardIdx = _selectedCardIndexes.first;
    _selectedCardIndexes.remove(polledCardIdx);
    return polledCardIdx;
  }
}
