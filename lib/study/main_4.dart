import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp4());
}

class MyApp4 extends StatelessWidget {
  const MyApp4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Stream Demo',
      home: MyHomePage4(),
    );
  }
}

class MyHomePage4 extends StatefulWidget {
  const MyHomePage4({Key? key}) : super(key: key);

  final String title = 'MyHomePage4';

  @override
  State<MyHomePage4> createState() => _MyHomePage4State();
}

class _MyHomePage4State extends State<MyHomePage4> {
  int _counter = 0;

  late final StreamController<int> _streamController;

  @override
  void initState() {
    super.initState();

    _streamController = StreamController(onListen: () {
        print('onListen');
    });
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  void _incrementCounter() {
    _streamController.add(_counter++);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder(
        stream: _streamController.stream,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              print('none');
              break;
            case ConnectionState.active:
              print('active');
              break;
            case ConnectionState.waiting:
              print('waiting');
              break;
            case ConnectionState.done:
              print('done');
              break;
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'You have pushed the button this many times:',
                ),
                Text(
                  '$_counter',
                  style: Theme
                      .of(context)
                      .textTheme
                      .headline4,
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
