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

enum FlipCardEvent {
  init,
  reset,
  check,
}

class FlipCardCore extends Bloc<FlipCardEvent, FlipCardGameState> {
  FlipCardCore() : super(InitialState()) {
    on<FlipCardEvent>((event, emit) {
      switch (event) {
        case FlipCardEvent.init:
        case FlipCardEvent.reset:
          _reset();
          emit(ResetState(randomImageNames: _randomImageNames));
          break;
        case FlipCardEvent.check:
          if (_backCardIndexes.length >= 2) {
            _checkCardIsEqual();
            emit(CheckCardState(randomImageNames: _randomImageNames));
          }
          break;
        default:
          break;
      }
    });
  }

  final _imageNames = [
    AssetImageName.orange,
    AssetImageName.banana,
    AssetImageName.apple,
    AssetImageName.strawberry,
  ];

  final List<int> _backCardIndexes = [];

  int get backCardLength => _backCardIndexes.length;

  final List<String> _randomImageNames = [];

  void _reset() {
    // add 2 times
    _randomImageNames.clear();
    _randomImageNames.addAll(_imageNames);
    _randomImageNames.addAll(_imageNames);

    // shuffle
    _randomImageNames.shuffle();
  }

  void toggleCard(int index) {
    _backCardIndexes.add(index);

    add(FlipCardEvent.check);
  }

  void _checkCardIsEqual() {
    String firstCardName = _randomImageNames[_backCardIndexes[0]];
    String secondCardName = _randomImageNames[_backCardIndexes[1]];
    if (firstCardName == secondCardName) {
      _randomImageNames[_backCardIndexes[0]] = '';
      _randomImageNames[_backCardIndexes[1]] = '';
    }

    _backCardIndexes.clear();
  }
}