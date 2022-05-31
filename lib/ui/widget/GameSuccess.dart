import 'package:flutter/material.dart';

import '../main/MyHomePage.dart';

 gameSuccessAnim(SudokuGamePageState state) {
  //crossAxisCount：列数，即一行有几个子元素；
  // mainAxisSpacing：主轴方向上的空隙间距；
  // crossAxisSpacing：次轴方向上的空隙间距；
  // childAspectRatio：子元素的宽高比例。
  GridView(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 9));
  return GridView.count(
      crossAxisCount: 9,
      mainAxisSpacing: 1,
      crossAxisSpacing: 1,
      padding: const EdgeInsets.symmetric(vertical: 0),
      children: List.generate(81, (index) {
        var controller = AnimationController(
            duration: Duration(milliseconds: 2000 + getIndex(index) * 50),
            vsync: state);
        controller.addStatusListener((astate) {
          if (astate == AnimationStatus.completed) {
            state.setState(() {});
          }
        });
        var tween =
            Tween(begin: 1.0, end: 0.0).chain(CurveTween(curve: Curves.ease));
        controller.forward();
        return ScaleTransition(
            scale: controller.drive(tween),
            child: Container(
              color: Colors.lightBlueAccent,
              child: Align(
                child: Text(""),
                alignment: Alignment.center,
              ),
            ));
      }));
}

int getIndex(int index) {
  var mod = index % 10;
  var mult = mod;
  if (mod == 0) {
    mult = 10;
  } else if (mod == 1 && index / 10 <= 7.1) {
    mult = 11;
  } else if (mod == 2 && index / 10 <= 6.2) {
    mult = 12;
  } else if (mod == 3 && index / 10 <= 5.3) {
    mult = 13;
  } else if (mod == 4 && index / 10 <= 4.4) {
    mult = 14;
  } else if (mod == 5 && index / 10 <= 3.5) {
    mult = 15;
  } else if (mod == 6 && index / 10 <= 2.6) {
    mult = 16;
  } else if (mod == 7 && index / 10 <= 1.7) {
    mult = 17;
  } else if (mod == 8 && index / 10 <= 0.8) {
    mult = 18;
  }
  return mult;
}
