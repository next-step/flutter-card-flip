import 'package:flip_card_game/model/cards.dart';

abstract class CardState {}

class InitialState extends CardState {}

class ResetCardState extends CardState {
  ResetCardState(this.cards);

  final Cards cards;
}

class CheckCardState extends CardState {
  CheckCardState(this.cards);

  final Cards cards;
}
