import 'package:flutter/material.dart';
import 'package:flutter_sudoku/main.dart';

bool isPortrait(BuildContext context) {
  if (MediaQuery.of(context).orientation == Orientation.portrait) {
    return true;
  } else {
    return false;
  }
}

void navTo(String route) {
  Navigator.pushNamed(sContext, route);
}

void navToPage(Widget page) {
  Navigator.push(sContext, MaterialPageRoute(builder: (context) {
    return page;
  }));
}
