import 'dart:async';

import 'package:flip_card_game/asset_name.dart';
import 'package:bloc/bloc.dart';

abstract class FlipCardGameState {}

class InitialState extends FlipCardGameState {}

class ResetState extends FlipCardGameState {
  ResetState({required this.randomImageNames});

  final List<String> randomImageNames;
}

class CheckCardState extends FlipCardGameState {
  CheckCardState({required this.randomImageNames});

  final List<String> randomImageNames;
}

class FlipCardCore extends Cubit<FlipCardGameState> {
  FlipCardCore() : super(InitialState());

  final _imageNames = [
    AssetImageName.orange,
    AssetImageName.banana,
    AssetImageName.apple,
    AssetImageName.strawberry,
  ];

  final List<int> _backCardIndexes = [];

  int get backCardLength => _backCardIndexes.length;

  final List<String> _randomImageNames = [];

  Stream<FlipCardGameState> get stream => _streamController.stream;

  final StreamController<FlipCardGameState> _streamController = StreamController.broadcast();

  void reset() {
    // add 2 times
    _randomImageNames.clear();
    _randomImageNames.addAll(_imageNames);
    _randomImageNames.addAll(_imageNames);

    // shuffle
    _randomImageNames.shuffle();
    emit(ResetState(randomImageNames: _randomImageNames));
  }

  void toggleCard(int index) {
    _backCardIndexes.add(index);

    _checkCardIsEqual();
  }

  void _checkCardIsEqual() {
    if (_backCardIndexes.length < 2) return;

    String firstCardName = _randomImageNames[_backCardIndexes[0]];
    String secondCardName = _randomImageNames[_backCardIndexes[1]];
    if (firstCardName == secondCardName) {
      _randomImageNames[_backCardIndexes[0]] = '';
      _randomImageNames[_backCardIndexes[1]] = '';
    }

    _backCardIndexes.clear();

    emit(CheckCardState(randomImageNames: _randomImageNames));
  }
}