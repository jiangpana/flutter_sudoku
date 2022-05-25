import 'package:flutter_sudoku/ext/Ext.dart';
import 'package:flutter_sudoku/ui/main/SudokuGameView.dart';
import 'package:flutter/material.dart';

late BuildContext sContext;

var screenWidth = MediaQuery.of(sContext).size.width;
var screenHeight = MediaQuery.of(sContext).size.height;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({key, this.title}) : super(key: key);

  late var title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  var colIndex = 0;
  var rowIndex = 0;

  void touch(int row, int col) {
    if ((0 <= row && row <= 8) && (0 <= col && col <= 8)) {
      setState(() {
        rowIndex = row;
        colIndex = col;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    sContext = context;
    return Scaffold(
      appBar: AppBar(
        title: Text("FlutterSudoku"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'GameSetting',
            onPressed: () {
              // handle the press
            },
          ),
        ],
      ),
      body: appContent(context, this),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          onClickNumber(this,0);
        },
        tooltip: 'Increment',
        child: Icon(Icons.clear),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

Widget appContent(BuildContext context, MyHomePageState state) {
  if (isPortrait(context)) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      verticalDirection: VerticalDirection.down,
      children: <Widget>[
        sudokuGameView(context, state),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            verticalDirection: VerticalDirection.down,
            children: List.generate(9, (index) {
              var value = ++index < 10 ? index : 0;
              return Container(
                  width: screenWidth / 10,
                  child: TextButton(
                    onPressed: () {
                      onClickNumber(state, value);
                    },
                    child: Text("$value",
                        style: TextStyle(fontSize: 25, color: Colors.black)),
                  ));
            })),
      ],
    );
  } else {
    return Row();
  }
}

void onClickNumber(MyHomePageState state, int value) {
  if (selectCell != null) {
    if (selectCell.isEditable) {
      print("_changValue");
      state.setState(() {
        data[selectCell.rowIndex][selectCell.colIndex].value = value;
        var success = true;
        data.forEach((element) {
          element.forEach((cell) {
            if (!cell.isValid()) {
              success = false;
            }
          });
        });
        if (success) {
          showGameSuccessDialog(reStart: () {
            reStartGame(state);
          });
        }
      });
    }
  }
}

void reStartGame(MyHomePageState state) {
  state.setState(() {
    data.forEach((element) {
      element.forEach((cell) {
        if (cell.isEditable) {
          cell.value = 0;
        }
      });
    });
  });
}

void showGameSuccessDialog({
  List<Widget>? children,
  VoidCallback? reStart,
}) {
  showDialog<void>(
    context: sContext,
    builder: (BuildContext context) {
      return AlertDialog(
        content: ListBody(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[Text("游戏成功")],
            ),
            ...?children,
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text("重新开始"),
            onPressed: () {
              reStart?.call();
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text("取消"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        scrollable: true,
      );
    },
  );
}
