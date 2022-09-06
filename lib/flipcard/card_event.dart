abstract class CardEvent {}

class ResetEvent extends CardEvent {}

class FlippingEvent extends CardEvent {
  final int index;

  FlippingEvent(this.index);
}

class FlipDoneEvent extends CardEvent {
  final int index;

  FlipDoneEvent(this.index);
}
