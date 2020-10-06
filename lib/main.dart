import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tetris/widgets/grid.dart';

import 'blocks/block.dart';
import './constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: TetrisGame(title: 'Flutter Demo Home Page'),
    );
  }
}

class TetrisGame extends StatefulWidget {
  TetrisGame({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _TetrisGameState createState() => _TetrisGameState();
}

class _TetrisGameState extends State<TetrisGame> {
  Block currentBlock;
  List<Point> bottomPoints;
  Timer ticker;
  bool alive;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    setState(() {
      // TODO alternate block shape
      alive = true;
      currentBlock = getRandomBlock();
      bottomPoints = List<Point>();
    });

    ticker = new Timer.periodic(TICKER_STEP, onTick);
  }

  void onTick(Timer timer) {
    if (canPlay() == false) {
      setState(() {
        this.alive = false;
      });
      timer.cancel();
      return;
    }

    if (this.currentBlock.canMoveDown(this.bottomPoints)) {
      setState(() {
        this.currentBlock.moveDown();
      });
    } else {
      setState(() {
        currentBlock.points.forEach((element) {
          bottomPoints.add(element);
        });
        currentBlock = getRandomBlock();
      });
    }
  }

  bool canPlay() {
    bool flag = true;
    this.bottomPoints.forEach((element) {
      if (element.y == 0) {
        flag = false;
      }
    });
    return flag;
  }

  Block getRandomBlock() {
    List<Block> blocks = List<Block>();
    blocks.add(TBlock());
    return blocks[0];
  }

  List<Point> getAllPoints() {
    List<Point> points = List<Point>();
    currentBlock.points.forEach((element) {
      points.add(element);
    });
    bottomPoints.forEach((element) {
      points.add(element);
    });
    return points;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TetrisGrid(points: this.getAllPoints()),
                    ),
                    Container(
                      width: 100,
                      child: Column(
                        children: [(this.alive == false) ? Text("Game Over") : Text("Play"),],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(icon: Icon(Icons.arrow_left), onPressed: null),
                  IconButton(icon: Icon(Icons.rotate_left), onPressed: null),
                  IconButton(icon: Icon(Icons.rotate_right), onPressed: null),
                  IconButton(icon: Icon(Icons.arrow_right), onPressed: null),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
