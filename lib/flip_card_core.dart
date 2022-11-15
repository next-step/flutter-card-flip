import 'package:bloc/bloc.dart';
import 'package:flip_card_game/gen/assets.gen.dart';
import 'package:flip_card_game/model/card.dart';
import 'package:flip_card_game/util/debug_logger.dart';

class RewriteCardEvent {
  final String name;

  const RewriteCardEvent({required this.name});
}

class CardBloc extends Bloc<RewriteCardEvent, ImageCard> {
  CardBloc(String name) : super(ImageCard(name: name)) {
    on<RewriteCardEvent>((event, emit) => emit(ImageCard(name: event.name)));
  }
}

class FlipToFrontCardEvent {
  final List<int> flipIndexes;

  const FlipToFrontCardEvent({required this.flipIndexes});
}

class CardListBloc extends Bloc<FlipToFrontCardEvent, List<int>> {
  CardListBloc() : super([]) {
    on<FlipToFrontCardEvent>((event, emit) => emit(event.flipIndexes));
  }
}

class FlipCardCore {
  static final List<String> _imageNames =
      Assets.images.values.map((e) => e.path).toList();

  final CardListBloc _cardListBloc = CardListBloc();

  Stream<List<int>> get flipFrontStream => _cardListBloc.stream;

  final List<CardBloc> _cards = _getInitCards();

  List<Stream<ImageCard>> get cardStreams =>
      _cards.map((e) => e.stream).toList();

  final Set<int> _selectedCardIndexes = {};

  int get selectedCount => _selectedCardIndexes.length;

  int get length => _cards.length;

  static List<CardBloc> _getInitCards() {
    List<CardBloc> cards = [];
    cards.addAll(_imageNames.map((e) => CardBloc(e)));
    cards.addAll(_imageNames.map((e) => CardBloc(e)));
    return cards;
  }

  void reset() {
    // reset selected states
    _selectedCardIndexes.clear();

    List<String> cards = [];
    cards.addAll(_imageNames);
    cards.addAll(_imageNames);

    // shuffle
    cards.shuffle();

    for (int i = 0; i < cards.length; i++) {
      _cards[i].add(RewriteCardEvent(name: cards[i]));
    }
    _cardListBloc.add(FlipToFrontCardEvent(
        flipIndexes: List.generate(_cards.length, (index) => index)));
  }

  void toggleCard(int idx, bool isSelect) {
    if (isSelect) {
      _selectCard(idx);
    } else {
      _unSelectCard(idx);
    }
  }

  void _selectCard(int idx) {
    _selectedCardIndexes.add(idx);
    debugPrint('selectCard index-${idx}');
    debugPrint(_selectedCardIndexes);
    _isEqual();
  }

  void _unSelectCard(int idx) {
    _selectedCardIndexes.remove(idx);
    debugPrint('unSelectCard index-$idx');
    debugPrint(_selectedCardIndexes);
  }

  void _isEqual() {
    debugPrint('_checkCardIsEqual');
    debugPrint(_selectedCardIndexes);

    if (_selectedCardIndexes.length >= 2) {
      int firstCardIdx = _pollSelectedCardIdx();
      String firstCardName = _cards[firstCardIdx].state.name;
      int secondCardIdx = _pollSelectedCardIdx();
      String secondCardName = _cards[secondCardIdx].state.name;
      if (firstCardName == secondCardName) {
        _cards[firstCardIdx].add(const RewriteCardEvent(name: ''));
        _cards[secondCardIdx].add(const RewriteCardEvent(name: ''));
        debugPrint('correct!');
        return;
      }
      debugPrint('incorrect!');
      _cardListBloc.add(FlipToFrontCardEvent(flipIndexes: [firstCardIdx, secondCardIdx]));
    }
  }

  int _pollSelectedCardIdx() {
    int polledCardIdx = _selectedCardIndexes.first;
    _selectedCardIndexes.remove(polledCardIdx);
    return polledCardIdx;
  }
}
