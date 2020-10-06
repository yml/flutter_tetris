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
      if (element.y + 1 > NB_ROWS - 1) {
        flag = false;
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

  bool canMoveRight(List<Point> floorPoints) {
    bool flag = true;
    this.points.forEach((element) {
      if (element.x + 1 > NB_COLUMNS - 1) {
        flag = false;
      }
      floorPoints.forEach((floorElement) {
        if (element.y == floorElement.y && element.x + 1 == floorElement.x) {
          flag = false;
        }
      });
    });
    return flag;
  }

  void moveRight() {
    this.points.forEach((element) {
      element.x++;
    });
  }

  bool canMoveLeft(List<Point> floorPoints) {
    bool flag = true;
    this.points.forEach((element) {
      if (element.x - 1 < 0) {
        flag = false;
      }
      floorPoints.forEach((floorElement) {
        if (element.y == floorElement.y && element.x - 1 == floorElement.x) {
          flag = false;
        }
      });
    });
    return flag;
  }

  void moveLeft() {
    this.points.forEach((element) {
      element.x--;
    });
  }

  bool canRotateLeft(List<Point> floorPoints){
    bool flag = true;
    Point rotationCenter = this.points[this.rotationCenterIdx];
    this.points.forEach((element) {
      Point rotatedPoint = rotatePointLeft(element, rotationCenter);
      if( 0 > rotatedPoint.x || rotatedPoint.x > NB_COLUMNS) {
        flag = false;
      }
      if (NB_ROWS < rotatedPoint.y ){
        flag = false;
      }
      floorPoints.forEach((floorElement) {
        if(floorElement.x == element.x && floorElement.y==element.y){
          flag= false;
        }
      });
    });

    return flag;
  }

  void rotateLeft() {
    Point rotationCenter = this.points[this.rotationCenterIdx];
    List<Point> rotatedPoints = List<Point>();
    this.points.forEach((element) {
      Point rotatedPoint = rotatePointLeft(element, rotationCenter);
      rotatedPoints.add(rotatedPoint);
    });
    this.points = rotatedPoints;
  }

  bool canRotateRight(List<Point> floorPoints){
    bool flag = true;
    Point rotationCenter = this.points[this.rotationCenterIdx];
    this.points.forEach((element) {
      Point rotatedPoint = rotatePointRight(element, rotationCenter);
      if( 0 > rotatedPoint.x || rotatedPoint.x > NB_COLUMNS-1) {
        flag = false;
      }
      if (NB_ROWS < rotatedPoint.y ){
        flag = false;
      }
      floorPoints.forEach((floorElement) {
        if(floorElement.x == element.x && floorElement.y==element.y){
          flag= false;
        }
      });
    });

    return flag;
  }

  void rotateRight() {
    Point rotationCenter = this.points[this.rotationCenterIdx];
    List<Point> rotatedPoints = List<Point>();
    this.points.forEach((element) {
      Point rotatedPoint = rotatePointRight(element, rotationCenter);
      rotatedPoints.add(rotatedPoint);
    });
    this.points = rotatedPoints;
  }
}

Point rotatePointRight(Point element, Point rotationCenter ) {
    int x = -1*( element.y -rotationCenter.y)+ rotationCenter.x;
    int y = (element.x - rotationCenter.x)+ rotationCenter.y;
    return Point(x, y, element.color,);
}

Point rotatePointLeft(Point element, Point rotationCenter) {
    int x = ( element.y -rotationCenter.y)+ rotationCenter.x;
    int y = -(element.x - rotationCenter.x)+ rotationCenter.y;
    return Point(x, y, element.color,);
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

class IBlock extends Block {
  IBlock() {
    final Color color = Colors.redAccent;
    points = List<Point>();
    points.add(Point((NB_COLUMNS / 2 - 2).floor(), 0, color));
    points.add(Point((NB_COLUMNS / 2 - 1).floor(), 0, color));
    points.add(Point((NB_COLUMNS / 2 - 0).floor(), 0, color));
    points.add(Point((NB_COLUMNS / 2 + 1).floor(), 0, color));
    points.add(Point((NB_COLUMNS / 2 + 2).floor(), 0, color));
    rotationCenterIdx = 0;
  }
}


class ZBlock extends Block {
  ZBlock() {
    final Color color = Colors.redAccent;
    points = List<Point>();
    points.add(Point((NB_COLUMNS / 2 - 1).floor(), 0, color));
    points.add(Point((NB_COLUMNS / 2 - 0).floor(), 0, color));
    points.add(Point((NB_COLUMNS / 2 + 0).floor(), 1, color));
    points.add(Point((NB_COLUMNS / 2 + 1).floor(), 1, color));
    rotationCenterIdx = 0;
  }
}


class CBlock extends Block {
  CBlock() {
    final Color color = Colors.redAccent;
    points = List<Point>();
    points.add(Point((NB_COLUMNS / 2 - 1).floor(), 0, color));
    points.add(Point((NB_COLUMNS / 2 - 0).floor(), 0, color));
    points.add(Point((NB_COLUMNS / 2 - 0).floor(), 1, color));
    points.add(Point((NB_COLUMNS / 2 - 1).floor(), 1, color));
    rotationCenterIdx = 0;
  }
}
