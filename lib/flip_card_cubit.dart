import 'package:flip_card_game/card_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'asset_name.dart';

List<String> getDefaultCardList() {
  List<String> list = [];
  List<String> _imageNames = [
    AssetImageName.orange,
    AssetImageName.banana,
    AssetImageName.apple,
    AssetImageName.strawberry,
  ];

  list.addAll(_imageNames);
  list.addAll(_imageNames);

  // shuffle
  list.shuffle();

  return list;
}

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
