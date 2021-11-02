import 'package:flutter/material.dart';

Widget removeScrollGlow({required Widget listChild, bool enable = true}) {
  if (enable) {
    return NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
          return true;
        },
        child: listChild);
  }
  return listChild;
}
