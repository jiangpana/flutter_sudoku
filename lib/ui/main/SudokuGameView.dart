import 'dart:math';
import 'package:flutter_sudoku/ext/Ext.dart';
import 'package:flutter_sudoku/main.dart';
import 'package:flutter_sudoku/game/Game.dart';
import 'package:flutter/material.dart';

late var width;
late double cellWidth;
late Cell selectCell;
late List<List<Cell>> data = QuesProvider().getQuesArray2d();
double padding = 8 ;

Widget sudokuGameView(BuildContext context, MyHomePageState state) {
  var size;
  if (isPortrait(context)) {
    size = MediaQuery.of(context).size.width;
  } else {
    size = MediaQuery.of(context).size.height;
  }
  return Listener(
    child: Padding(
      padding: new EdgeInsets.all(padding),
      child: CustomPaint(
        size: Size(size, size),
        painter: SudokuGamePainter(context, state),
      ),
    ),
    onPointerMove: (PointerEvent event) => handleMotionEvent(event, state),
    onPointerDown: (PointerEvent event) => handleMotionEvent(event, state),
    onPointerUp: (PointerEvent event) => handleMotionEvent(event, state),
  );
}

bool handleMotionEvent(PointerEvent it, MyHomePageState state) {
  var row = ((it.localPosition.dy - padding) / cellWidth).truncate();
  var col = ((it.localPosition.dx - padding) / cellWidth).truncate();
  state.touch(row, col);
  return true;
}

class SudokuGamePainter extends CustomPainter {
  late Paint lingPaint;
  late Paint hignPaint;
  late BuildContext context;
  late MyHomePageState state;

  SudokuGamePainter(BuildContext context, MyHomePageState state) {
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
        if(cell.value != 0){
          var color;
          if(cell.isEditable){
            color = Color(0xff1D62BF) ;
          } else{
            color = Colors.black ;
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
    for (var index = 0; index < 9; index++) {
      lingPaint.strokeWidth = 1;
      var colStart = Offset(index * cellWidth, 0);
      var colEnd = Offset(index * cellWidth, width);
      canvas.drawLine(colStart, colEnd, lingPaint);
      var rowStart = Offset(0, index * cellWidth);
      var rowEnd = Offset(width, index * cellWidth);
      canvas.drawLine(rowStart, rowEnd, lingPaint);
    }
    for (var index = 0; index < 4; index++) {
      var colStart = Offset(index * cellWidth * 3, 0);
      var colEnd = Offset(index * cellWidth * 3, width);
      lingPaint.strokeWidth = 4;
      canvas.drawLine(colStart, colEnd, lingPaint);
      var rowStart = Offset(0, index * cellWidth * 3);
      var rowEnd = Offset(width, index * cellWidth * 3);
      canvas.drawLine(rowStart, rowEnd, lingPaint);
    }
  }

  void drawHighlightColRowSec(Canvas canvas) {
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
    hignPaint.color = Color(0xff88C2FF);

    canvas.drawRect(
        Rect.fromLTRB(
            selectCell.colIndex * cellWidth,
            selectCell.rowIndex * cellWidth,
            selectCell.colIndex * cellWidth + cellWidth,
            selectCell.rowIndex * cellWidth + cellWidth),
        hignPaint);
  }

  void drawSimilarCell(Canvas canvas) {}
}