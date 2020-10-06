import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import '../blocks/block.dart';
import '../constants.dart';


class TetrisGrid extends StatelessWidget {
  const TetrisGrid({
    Key key,
    this.points,
  }) : super(key: key);

  final List<Point> points;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      print("grid height: " + constraints.maxHeight.toString());
      print("grid width: " + constraints.maxWidth.toString());
      print("grid points: "+ this.points.toString());
      final double height = constraints.maxHeight / NB_ROWS;
      final double width = constraints.maxWidth / NB_COLUMNS;

      double side;
      if (height < width){
        side =height; 
      } else{
        side = width;
      }

      List<Widget> rows = new List<Widget>();
      for (var i = 0; i < NB_ROWS; i++) {
        List<Point> rowPoints  =  List<Point>();
        this.points.forEach((element) {
          if (element.y == i) {
            rowPoints.add(element);
          }
        });
        rows.add(TetrisRow(
          nbColumns: NB_COLUMNS,
          side: side,
          points: rowPoints,
        ));
      }

      return Column(
        children: rows,
      );
    });
  }
}

class TetrisRow extends StatelessWidget {
  const TetrisRow({
    Key key,
    this.nbColumns,
    this.side,
    this.points
  }) : super(key: key);

  final int nbColumns;
  final double side;
  final List<Point> points;

  @override
  Widget build(BuildContext context) {
    List<Widget> cols = new List<Widget>();
    for (var i = 0; i < nbColumns; i++) {
      Color color = Colors.cyanAccent;
      this.points.forEach((element) {
        if (element.x == i){
          color = element.color;
        }
      });
      cols.add(TetrisCell(
        side: this.side,
        color: color,
      ));
    }
    return Row(
      children: cols,
    );
  }
}

class TetrisCell extends StatelessWidget {
  const TetrisCell({
    Key key,
    this.side,
    this.color,
  }) : super(key: key);

  final double side;
  final Color  color;

  @override
  Widget build(BuildContext context) {
    print("side: " + this.side.toString());
    return SizedBox(
        width: this.side,
        height: this.side,
        child: Container(
          decoration: BoxDecoration(
              color: this.color,
              borderRadius: BorderRadius.all(Radius.circular(3))),
        ));
  }
}
