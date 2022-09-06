import 'package:flip_card_game/card_state.dart';
import 'package:flip_card_game/util/card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class FlipCardEvent {}

class ResetCardList extends FlipCardEvent {}

class UpdateCardList extends FlipCardEvent {
  List<String> randomImageNames;

  UpdateCardList({required this.randomImageNames});
}

class FlipCardBloc extends Bloc<FlipCardEvent, CardState> {
  FlipCardBloc() : super(InitialCardState(getDefaultCardList())) {
    on<ResetCardList>((event, emit) {
      List<String> list = getDefaultCardList();

      emit(InitialCardState(list));
    });
    on<UpdateCardList>((event, emit) {
      emit(UpdateCardState(event.randomImageNames));
    });
  }
}
