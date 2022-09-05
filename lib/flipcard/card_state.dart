import 'package:flip_card_game/model/cards.dart';

abstract class CardState {
  CardState(this.cards);

  final Cards cards;
}

class InitialState extends CardState {
  InitialState(Cards cards) : super(cards);
}

class CheckCardState extends CardState {
  CheckCardState(Cards cards) : super(cards);
}
