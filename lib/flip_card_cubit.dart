import 'package:flip_card_game/card_state.dart';
import 'package:flip_card_game/util/card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlipCardCubit extends Cubit<CardState> {
  final List<String> randomImageNames = [];

  FlipCardCubit(CardState initialState) : super(initialState);

  void reset() {
    List<String> list = getDefaultCardList();

    emit(InitialCardState(list));
  }

  void update(List<String> list) {
    emit(UpdateCardState(list));
  }
}
