import 'dart:math';
import 'package:flutter_sudoku/ext/Ext.dart';
import 'package:flutter_sudoku/game/Game.dart';
import 'package:flutter/material.dart';

import '../widget/GameSuccess.dart';
import 'MyHomePage.dart';

late var width;
late double cellWidth;
late Cell selectCell;
late List<List<Cell>> data = QuesProvider().getQuesArray2d();
double padding = 8;

/*
return Listener(
child: Padding(
padding: new EdgeInsets.all(padding),
child:
CustomPaint(
size: Size(size, size),
painter: SudokuGamePainter(context, state),)
),
onPointerMove: (PointerEvent event) => handleMotionEvent(event, state),
onPointerDown: (PointerEvent event) => handleMotionEvent(event, state),
onPointerUp: (PointerEvent event) => handleMotionEvent(event, state),
);
*/

Widget sudokuGameView(BuildContext context, SudokuGamePageState state) {
  var size = isPortrait(context)
      ? MediaQuery.of(context).size.width
      : MediaQuery.of(context).size.height;
  var child = <Widget>[
    Listener(
      child: Padding(
          padding: new EdgeInsets.all(padding),
          child: CustomPaint(
            size: Size(size, size),
            painter: SudokuGamePainter(context, state),
          )),
      onPointerMove: (PointerEvent event) => handleMotionEvent(event, state),
      onPointerDown: (PointerEvent event) => handleMotionEvent(event, state),
      onPointerUp: (PointerEvent event) => handleMotionEvent(event, state),
    ),
  ];
  if (state.newGame) {
    state.newGame = false;
    child.add(Padding(
      padding: new EdgeInsets.all(padding),
      child: Container(
        child: gameSuccessAnim(state),
        width: size,
        height: size,
      ),
    ));
  }
  return Stack(
    children: child,
  );
}

bool handleMotionEvent(PointerEvent it, SudokuGamePageState state) {
  var row = ((it.localPosition.dy - padding) / cellWidth).truncate();
  var col = ((it.localPosition.dx - padding) / cellWidth).truncate();
  state.move(row, col);
  return true;
}

class SudokuGamePainter extends CustomPainter {
  late Paint lingPaint;
  late Paint hignPaint;
  late BuildContext context;
  late SudokuGamePageState state;

  SudokuGamePainter(BuildContext context, SudokuGamePageState state) {
    this.context = context;
    this.state = state;
    selectCell = data[0][0];
    lingPaint = Paint()
      ..color = Colors.black //画笔颜色
      ..strokeCap = StrokeCap.round //画笔笔触类型
      ..isAntiAlias = true //是否启动抗锯齿
      ..strokeWidth = 1; //画笔的宽度

    hignPaint = Paint()
      ..color = Color(0xffD8EBFF) //画笔颜色
      ..strokeCap = StrokeCap.round //画笔笔触类型
      ..isAntiAlias = true //是否启动抗锯齿
      ..strokeWidth = 1; //画笔的宽度
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      width = size.width;
    } else {
      width = size.height;
    }
    cellWidth = (width / 9);
    selectCell = data[state.rowIndex][state.colIndex];
    drawHighlightColRowSec(canvas);
    drawSimilarCell(canvas);
    drawLine(canvas);
    drawCellValue(canvas);
  }

  void drawCellValue(Canvas canvas) {
    for (var rowIndex = 0; rowIndex < 9; rowIndex++) {
      for (var colIndex = 0; colIndex < 9; colIndex++) {
        var cell = data[rowIndex][colIndex];
        if (cell.value != 0) {
          var color;
          var selectCellVal = selectCell.value;
          if (state.hignSimilarCell) {
            if (cell.isEditable &&
                (cell.value != selectCellVal || cell == selectCell)) {
              color = Colors.blue;
            } else if (cell.value == selectCellVal && cell != selectCell) {
              color = Colors.white;
            } else {
              color = Colors.black;
            }
          } else {
            if (cell.isEditable) {
              color = Colors.blue;
            } else {
              color = Colors.black;
            }
          }
          if (state.errorCheck) {
            if (!cell.isValid()) {
              color = Colors.red;
            }
          }
          var textPainter = TextPainter(
              textDirection: TextDirection.rtl,
              textWidthBasis: TextWidthBasis.longestLine,
              maxLines: 1,
              text: TextSpan(
                  text: cell.value.toString(),
                  style: TextStyle(color: color, fontSize: 20)))
            ..layout();

          var height = textPainter.height;
          var width = textPainter.width;
          var startX = colIndex * cellWidth + (cellWidth / 2 - width / 2);
          var startY = rowIndex * cellWidth + (cellWidth / 2 - height / 2);
          textPainter.paint(canvas, Offset(startX, startY));
        }
      }
    }
  }

  void drawLine(Canvas canvas) {
    for (var index = 1; index < 9; index++) {
      lingPaint.strokeWidth = 1;
      var colStart = Offset(index * cellWidth, 0);
      var colEnd = Offset(index * cellWidth, width);
      canvas.drawLine(colStart, colEnd, lingPaint);
      var rowStart = Offset(0, index * cellWidth);
      var rowEnd = Offset(width, index * cellWidth);
      canvas.drawLine(rowStart, rowEnd, lingPaint);
    }
    for (var index = 0; index < 3; index++) {
      var colStart = Offset(index * cellWidth * 3, 0);
      var colEnd = Offset(index * cellWidth * 3, width);
      var rowStart = Offset(0, index * cellWidth * 3);
      var rowEnd = Offset(width, index * cellWidth * 3);
      lingPaint.strokeWidth = 3;
      if (index == 0) {
        //绘制最外层边框
        lingPaint.style = PaintingStyle.stroke;
        lingPaint.strokeCap = StrokeCap.square;
        lingPaint.isAntiAlias = true;
        RRect rRect = RRect.fromLTRBR(
            0, 0, cellWidth * 9, cellWidth * 9, Radius.circular(3));
        canvas.drawRRect(rRect, lingPaint);
      } else {
        canvas.drawLine(colStart, colEnd, lingPaint);
        canvas.drawLine(rowStart, rowEnd, lingPaint);
      }
    }
  }

  void drawHighlightColRowSec(Canvas canvas) {
    if (state.hignColRowSec) {
      // 绘制高亮列
      hignPaint.color = Color(0xffD8EBFF);
      var hColLeft = selectCell.colIndex * cellWidth;
      canvas.drawRect(
          Rect.fromLTRB(hColLeft, 0, hColLeft + cellWidth, cellWidth * 9),
          hignPaint);
      var hRowTop = selectCell.rowIndex * cellWidth;
      canvas.drawRect(
          Rect.fromLTRB(0, hRowTop, cellWidth * 9, hRowTop + cellWidth),
          hignPaint);
      var cell = selectCell.sector.getCell(0);
      var secL = cell.colIndex * cellWidth;
      var secT = cell.rowIndex * cellWidth;
      canvas.drawRect(
          Rect.fromLTRB(secL, secT, secL + cellWidth * 3, secT + cellWidth * 3),
          hignPaint);
    }
    hignPaint.color = Color(0xff88C2FF);
    canvas.drawRect(
        Rect.fromLTRB(
            selectCell.colIndex * cellWidth,
            selectCell.rowIndex * cellWidth,
            selectCell.colIndex * cellWidth + cellWidth,
            selectCell.rowIndex * cellWidth + cellWidth),
        hignPaint);
  }

  void drawSimilarCell(Canvas canvas) {
    if (!state.hignSimilarCell) return;
    hignPaint.color = Colors.green;
    var curVal = selectCell.value;
    for (var element in data) {
      for (var cell in element) {
        if (cell.value == curVal && cell != selectCell && cell.value != 0) {
          var rect = Rect.fromLTRB(
              cell.colIndex * cellWidth,
              cell.rowIndex * cellWidth,
              (cell.colIndex + 1) * cellWidth,
              (cell.rowIndex + 1) * cellWidth);
          canvas.drawRect(rect, hignPaint);
        }
      }
    }
  }
}
