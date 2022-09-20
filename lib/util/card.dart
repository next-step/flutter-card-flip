import '../asset_name.dart';

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
