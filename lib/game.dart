import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import './widgets/grid.dart';
import './constants.dart';
import './blocks/block.dart';

enum EventType { LEFT, RIGHT, DOWN, ROTATE_LEFT, ROTATE_RIGHT }

class TetrisGame extends StatefulWidget {
  TetrisGame({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _TetrisGameState createState() => _TetrisGameState();
}

class _TetrisGameState extends State<TetrisGame> {
  Block currentBlock;
  List<Point> bottomPoints;
  Timer ticker;
  Timer tickerDown;
  bool alive;
  List<EventType> eventsBus;

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
    });
    bottomPoints = List<Point>();
    eventsBus = List<EventType>();
    ticker = new Timer.periodic(TICKER_STEP, onTick);
    tickerDown = new Timer.periodic(TICKER_STEP_DOWN, onTickDown);
  }

  void onTickDown(Timer timer){
    this.eventsBus.add(EventType.DOWN);
  }
  void onTick(Timer timer) {
    if (canPlay() == false) {
      setState(() {
        this.alive = false;
      });
      this.tickerDown.cancel();
      timer.cancel();
    }
    print("eventBus: " + this.eventsBus.toString());

    EventType currentEvent ;
    if (this.eventsBus.length > 0) {
      currentEvent = this.eventsBus.first;
      this.eventsBus.removeAt(0);
    }

    if (currentEvent == EventType.RIGHT &&
        this.currentBlock.canMoveRight(this.bottomPoints)) {
      setState(() {
        this.currentBlock.moveRight();
      });
    }
    if (currentEvent == EventType.LEFT &&
        this.currentBlock.canMoveLeft(this.bottomPoints)) {
      setState(() {
        this.currentBlock.moveLeft();
      });
    }

    if (currentEvent == EventType.ROTATE_LEFT &&
        this.currentBlock.canRotateLeft(this.bottomPoints)){
      setState(() {
        this.currentBlock.rotateLeft();
      });
    }

    if (currentEvent == EventType.ROTATE_RIGHT &&
        this.currentBlock.canRotateRight(this.bottomPoints)){
      setState(() {
        this.currentBlock.rotateRight();
      });
    }

    if (currentEvent == EventType.DOWN) {
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
    blocks.add(IBlock());
    blocks.add(ZBlock());
    blocks.add(CBlock());
    blocks.shuffle();

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

  void moveLeft() {
    this.eventsBus.add(EventType.LEFT);
  }

  void moveRight() {
    this.eventsBus.add(EventType.RIGHT);
  }

  void moveDown() {
    this.eventsBus.add(EventType.DOWN);
  }

  void moveRotateLeft() {
    this.eventsBus.add(EventType.ROTATE_LEFT);
  }

  void moveRotateRight() {
    this.eventsBus.add(EventType.ROTATE_RIGHT);
  }

  @override
  Widget build(BuildContext context) {
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
                        children: [
                          (this.alive == false)
                              ? Text("Game Over")
                              : Text("Play"),
                          IconButton(
                              icon: Icon(Icons.play_arrow),
                              onPressed: this.startGame)
                        ],
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
                  IconButton(
                      icon: Icon(Icons.arrow_back), onPressed: this.moveLeft),
                  IconButton(
                      icon: Icon(Icons.rotate_left),
                      onPressed: this.moveRotateLeft),
                  IconButton(
                      icon: Icon(Icons.arrow_downward),
                      onPressed: this.moveDown),
                  IconButton(
                      icon: Icon(Icons.rotate_right),
                      onPressed: this.moveRotateRight),
                  IconButton(
                      icon: Icon(Icons.arrow_forward), onPressed: this.moveRight),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
