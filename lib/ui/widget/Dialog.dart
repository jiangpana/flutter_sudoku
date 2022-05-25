


import 'package:flutter_sudoku/main.dart';
import 'package:flutter/material.dart';

late OverlayEntry weixinOverlayEntry;

/// 展示微信下拉的弹窗
void showWeixinButtonView() {
  weixinOverlayEntry = OverlayEntry(
    builder: (context) {
      return Positioned(
        top: 10,
        right: 20,
        height: 320,
        width: 200,
        child: SafeArea(
          child: Material(
            color: Colors.black,
            child: Column(
              children: [
                _ExpandedItem('发起群聊', () {
                  weixinOverlayEntry.remove();
                }),
                _ExpandedItem('添加朋友', () {
                  weixinOverlayEntry.remove();
                }),
                _ExpandedItem('扫一扫', () {
                  weixinOverlayEntry.remove();
                }),
                _ExpandedItem('首付款', () {
                  weixinOverlayEntry.remove();
                }),
                _ExpandedItem('帮助与反馈', () {
                  weixinOverlayEntry.remove();
                }),
              ],
            ),
          ),
        ),
      );
    },
  );
  Overlay.of(sContext)?.insert(weixinOverlayEntry);
}

_ExpandedItem(String title, GestureTapCallback callback) => GestureDetector(
  onTap: callback,
  child: Expanded(
    child: ListTile(
      leading: Icon(Icons.add, color: Colors.white),
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
    ),
  ),
);

