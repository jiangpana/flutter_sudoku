import 'package:flutter/material.dart';
import 'package:flutter_sudoku/ui/setting/GameSettingPage.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/Constant.dart';
import '../../ext/Ext.dart';
import '../../main.dart';
import '../../util/SpUtil.dart';
import 'SudokuGameView.dart';

class SudokuGamePage extends StatefulWidget {
  static const route = '/sudoku/game';

  const SudokuGamePage({key}) : super(key: key);

  @override
  SudokuGamePageState createState() => SudokuGamePageState();
}

class SudokuGamePageState extends State<SudokuGamePage> with RouteAware ,TickerProviderStateMixin {
  var colIndex = 0;
  var rowIndex = 0;
  var newGame =true;

  @override
  void didPopNext() {
    print("didPopNext");
    setState((){});
  }

  @override
  void didPushNext() {
    print("didPushNext");
  }

  @override
  void didPop() {
    print("didPop");
  }
  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context)!); //订阅
    super.didChangeDependencies();
  }
  @override
  void dispose() {
    routeObserver.unsubscribe(this); //取消订阅
    super.dispose();
  }
  @override
  void didPush() {
    print("didPush");
  }



  SudokuGamePageState() {}

  bool get errorCheck {
    return SpUtil.preferences.getBool(Constant.setting_error_check)?? true;
  }

  bool get hignColRowSec {
    return SpUtil.preferences.getBool(Constant.setting_hign_col_row_sec)?? true;
  }

  bool get hignSimilarCell {
    return SpUtil.preferences.getBool(Constant.setting_hign_similar_cell)?? true;
  }

  void move(int row, int col) {
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
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(sContext).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("FlutterSudoku"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'GameSetting',
            onPressed: () {
              navToPage(GameSettingPage());
              // handle the press
            },
          ),
        ],
      ),
      body: appContent(context, this),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          onClickNumber(this, 0);
        },
        tooltip: 'Increment',
        child: Icon(Icons.clear),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

Widget appContent(BuildContext context, SudokuGamePageState state) {
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
              // var screenWidth = MediaQuery.of(context).size.width;
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

void onClickNumber(SudokuGamePageState state, int value) {
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
            state.newGame =true;
            reStartGame(state);
          });
        }
      });
    }
  }
}

void reStartGame(SudokuGamePageState state) {
  state.colIndex = 0;
  state.rowIndex = 0;
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Lottie.asset('anim/game_success.json'),
                Text("游戏成功!")],
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
