import 'dart:async';

import 'asset_name.dart';

class FlipCardCore {
  final _imageNames = [
    AssetImageName.orange,
    AssetImageName.banana,
    AssetImageName.apple,
    AssetImageName.strawberry,
  ];

  final List<String> _randomImageNames = [];
  int _frontCardCount = 0;
  final List<int> _frontCardIndexes = [];

  final StreamController toggleCardToFrontStream = StreamController();
  final StreamController cardsMatchedStream = StreamController();

  List<String> getRandomCardImages() {
    return _randomImageNames.map((e) => e).toList();
  }

  void reset() {
    // add 2 times
    _randomImageNames.clear();
    _randomImageNames.addAll(_imageNames);
    _randomImageNames.addAll(_imageNames);

    // shuffle
    _randomImageNames.shuffle();
  }

  void flipCard(int cardIndex) {
    _frontCardCount++;
    _frontCardIndexes.add(cardIndex);
  }

  void checkCards() {
    print('_frontCardCount : $_frontCardCount');
    print('_frontCardIndexes : $_frontCardIndexes');

    if (_frontCardCount == 2) {
      toggleCardToFrontStream.add(true);
      if (_frontCardIndexes.length >= 2) {
        String firstCardName = _randomImageNames[_frontCardIndexes[0]];
        String secondCardName = _randomImageNames[_frontCardIndexes[1]];
        if (firstCardName == secondCardName) {
          _randomImageNames[_frontCardIndexes[0]] = '';
          _randomImageNames[_frontCardIndexes[1]] = '';

          cardsMatchedStream.add(true);
        }
      }

      _frontCardIndexes.clear();
      _frontCardCount = 0;
    }
  }

  void dispose() {
    toggleCardToFrontStream.close();
    cardsMatchedStream.close();
  }
}
