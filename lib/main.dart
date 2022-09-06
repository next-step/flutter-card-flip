import 'package:flip_card/flip_card.dart';
import 'package:flip_card_game/card_state.dart';
import 'package:flip_card_game/flip_card_cubit.dart';
import 'package:flip_card_game/util/card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FlipCardCubit(InitialCardState(getDefaultCardList())),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<GlobalKey<FlipCardState>> _cardKeys = [];
  final List<int> _frontCardIndexes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: BlocBuilder<FlipCardCubit, CardState>(
        builder: (BuildContext context, state) {
          var randomImageNames = state.randomImageNames;

          if (_cardKeys.isEmpty) {
            _cardKeys.clear();
            _cardKeys.addAll(
                randomImageNames.map((_) => GlobalKey<FlipCardState>()));
          }

          return _buildCardListWidget(
              randomImageNames: randomImageNames,
              onFlipDone: (index) => _onFlipDone(
                  randomImageNames: randomImageNames,
                  index: index,
                  update: context.read<FlipCardCubit>().update));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<FlipCardCubit>().reset();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildCardListWidget({randomImageNames, onFlipDone}) {
    return Center(
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: List.generate(
          randomImageNames.length,
          (index) {
            if (randomImageNames[index].isEmpty || _cardKeys.isEmpty) {
              return Container(
                width: 100,
                height: 150,
                color: Colors.transparent,
              );
            }
            return FlipCard(
              key: _cardKeys[index],
              onFlipDone: (isFront) => {
                if (!isFront) {onFlipDone(index)}
              },
              front: Container(
                width: 100,
                height: 150,
                color: Colors.orange,
              ),
              back: Container(
                width: 100,
                height: 150,
                child: Image.asset(
                  randomImageNames[index],
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _onFlipDone({randomImageNames, index, update}) {
    _frontCardIndexes.add(index);

    if (_frontCardIndexes.length == 2) {
      String firstCardName = randomImageNames[_frontCardIndexes[0]];
      String secondCardName = randomImageNames[_frontCardIndexes[1]];

      if (firstCardName == secondCardName) {
        randomImageNames[_frontCardIndexes[0]] = '';
        randomImageNames[_frontCardIndexes[1]] = '';
      }

      _frontCardIndexes.clear();
      _toggleCardToFront();
    }

    update(randomImageNames);
  }

  void _toggleCardToFront() {
    for (var cardKey in _cardKeys) {
      if (cardKey.currentState == null) continue;

      if (!cardKey.currentState!.isFront) {
        cardKey.currentState!.toggleCard();
      }
    }
  }
}
