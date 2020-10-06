import 'package:flutter/material.dart';

import '../constants.dart';

class Point {
  int x;
  int y;
  Color color;

  Point(this.x, this.y, this.color);
}

class Block {
  List<Point> points;
  int rotationCenterIdx;

  bool canMoveDown(List<Point> floorPoints) {
    bool flag = true;
    this.points.forEach((element) {
      if (element.y +1  > NB_ROWS-1) {
        flag =  false;
      }
      floorPoints.forEach((floorElement) {
        if (element.x == floorElement.x && element.y + 1 == floorElement.y) {
          flag = false;
        }
      });
    });
    return flag;
  }

  void moveDown() {
    this.points.forEach((element) {
      element.y++;
    });
  }

  void moveRight() {
    this.points.forEach((element) {
      element.x++;
    });
  }

  void moveLeft() {
    this.points.forEach((element) {
      element.x--;
    });
  }
}

class TBlock extends Block {
  TBlock() {
    final Color color = Colors.redAccent;
    points = List<Point>();
    points.add(Point((NB_COLUMNS / 2 - 1).floor(), 0, color));
    points.add(Point((NB_COLUMNS / 2 - 0).floor(), 0, color));
    points.add(Point((NB_COLUMNS / 2 - 0).floor(), 1, color));
    points.add(Point((NB_COLUMNS / 2 + 1).floor(), 0, color));
    rotationCenterIdx = 1;
  }
}
