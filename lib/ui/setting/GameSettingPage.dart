import 'package:flutter/material.dart';
import 'package:flutter_sudoku/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/Constant.dart';
import '../../util/SpUtil.dart';

class GameSettingPage extends StatefulWidget {
  static const route = '/sudoku/setting';

  GameSettingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return GameSettingPageState();
  }
}

class GameSettingPageState extends State<GameSettingPage> {
  var settings = [

    ListItem(
        title: "错误检查",
        TAG: Constant.setting_error_check,
        isCheck: SpUtil.preferences.getBool(Constant.setting_error_check)??true) ,
    ListItem(
        title: "高亮行/列/宫",
        TAG: Constant.setting_hign_col_row_sec,
        isCheck:
        SpUtil.preferences.getBool(Constant.setting_hign_col_row_sec)??true),
    ListItem(
        title: "高亮相似单元格",
        TAG: Constant.setting_hign_similar_cell,
        isCheck: SpUtil.preferences.getBool(Constant.setting_hign_similar_cell)??true)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("设置"),
        ),
        body: _settingContent(context, this));
  }

  _settingContent(
      BuildContext context, GameSettingPageState gameSettingPageState) {
    return Column(
      children: List.generate(settings.length, (index) {
        var item = settings[index];
        return Container(
          color: Colors.white,
          child: Row(
            children: [
              Container(
                width: 10,
              ),
              Text(" ${item.title}"),
              Expanded(child: Container()),
              Switch(
                value: item.isCheck,
                activeColor: Colors.blue,
                inactiveTrackColor: Colors.blue.shade50,
                onChanged: (value) {
                  onCheck(item);
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  void onCheck(ListItem item) {
    print("onCheck：");
    setState(() {
      item.isCheck = !item.isCheck;
      SpUtil.preferences.setBool("${item.TAG}", item.isCheck);
    });
  }
}

class ListItem {
  ListItem({
    required this.title,
    required this.TAG,
    this.isCheck = false,
  }) {}
  late String? title;
  bool isCheck = false;
  late String TAG;
}
