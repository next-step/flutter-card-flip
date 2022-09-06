import 'dart:async';
import 'asset_name.dart';

class FlipCardCore {
  FlipCardCore() {
    reset();
  }

  final StreamController<List<String>> _streamController = StreamController();

  final _imageNames = [
    AssetImageName.orange,
    AssetImageName.banana,
    AssetImageName.apple,
    AssetImageName.strawberry,
  ];

  final List<String> _randomImageNames = [];
  final List<int> _frontCardIndexes = [];

  Stream<List<String>> get stream => _streamController.stream;

  void reset() {
    // add 2 times
    _randomImageNames.clear();
    _randomImageNames.addAll(_imageNames);
    _randomImageNames.addAll(_imageNames);

    // shuffle
    _randomImageNames.shuffle();

    _streamController.add(_randomImageNames);
  }

  void dispose() {
    _streamController.close();
  }

  void onFlipDone(index) {
    _frontCardIndexes.add(index);

    if (_frontCardIndexes.length == 2) {
      String firstCardName = _randomImageNames[_frontCardIndexes[0]];
      String secondCardName = _randomImageNames[_frontCardIndexes[1]];

      if (firstCardName == secondCardName) {
        _randomImageNames[_frontCardIndexes[0]] = '';
        _randomImageNames[_frontCardIndexes[1]] = '';
      }

      _streamController.add(_randomImageNames);
      _frontCardIndexes.clear();
    }
  }
}
