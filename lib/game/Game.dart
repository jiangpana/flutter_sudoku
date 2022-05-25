

import '../data/Constant.dart';

class Cell {
  var rowIndex = -1;
  var colIndex = -1;
  var value = -1;
  var ansValue = -1;
  var isEditable = true;

  late CellGroup sector;
  late CellGroup row;
  late CellGroup col;

  bool isValid() {
    return value == ansValue;
  }
}

class CellGroup {
  List mCells =[];

  void addCell(Cell cell) {
    mCells.add(cell);
  }

  Cell getCell(int index) {
    return mCells[0];
  }
}

class QuesProvider {
  List<List<Cell>> getQuesArray2d() {
    var ques = Constant.ques;
    var answ = Constant.answ;
    var sectors =List.generate(9, (index) =>new CellGroup());
    var rows = List.generate(9, (index) => new CellGroup());
    var cols =List.generate(9, (index) =>new CellGroup());
    var array2d = List.generate(9, (rowIndex) =>
        List.generate(9, (colIndex) => Cell(),growable: false)
        ,growable: false);
    var index = 0;
    for (var rowIndex = 0; rowIndex < 9; rowIndex++) {
      for (var colIndex = 0; colIndex < 9; colIndex++) {
        var cell = new Cell();
        array2d[rowIndex][colIndex] = cell;
        var cellVal = ques[index].toString();
        var ansVal = answ[index++].toString();
        cell.rowIndex = rowIndex;
        cell.colIndex = colIndex;
        cell.value = int.parse(cellVal);
        cell.ansValue = int.parse(ansVal);
        cell.isEditable = (cell.value == 0);
        var row = rows[rowIndex];
        var col = cols[colIndex];
        var sectIndex =
            ((colIndex / 3).truncate() * 3) + (rowIndex / 3).truncate();
        var sector = sectors[sectIndex];
        cell.row =row;
        cell.col =col;
        cell.sector =sector;
        cell.row.addCell(cell);
        cell.col .addCell(cell);
        cell.sector.addCell(cell);
      }
    }
    return array2d;
  }
}
