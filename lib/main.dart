import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_sudoku/ui/main/MyHomePage.dart';
import 'package:flutter_sudoku/ui/setting/GameSettingPage.dart';
import 'package:flutter_sudoku/util/SpUtil.dart';

late BuildContext sContext;

late double screenWidth;

late double screenHeight;
final RouteObserver<Route<dynamic>> routeObserver = RouteObserver();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  realRunApp();
}

void realRunApp() async {
  try {
    //设置高刷模式
    await FlutterDisplayMode.setHighRefreshRate();
  } on Exception catch (e) {
  }

  await SpUtil.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorObservers: [routeObserver],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SudokuGamePage(),
    );
  }
}
