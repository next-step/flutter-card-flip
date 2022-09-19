abstract class CardState {
  CardState(this.randomImageNames);

  final List<String> randomImageNames;
}

class InitialCardState extends CardState {
  InitialCardState(List<String> randomImageNames) : super(randomImageNames);
}

class UpdateCardState extends CardState {
  UpdateCardState(List<String> randomImageNames) : super(randomImageNames);
}
