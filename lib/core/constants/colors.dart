import 'package:flutter/material.dart';

abstract class AppColor {
  AppColor._();

  static Color get primaryColor => const Color(0xff00B9A0);
  ///message screen
  static Color get chatCircleAvatarColor => const  Color(0xffC4C4C4);
  static Color get chatBubbleOwnColor => const  Color(0xffF2F2F2);
  static Color get chatBubbleReceiverColor => const  Color(0xff00B9A0);
  static Color get chatTextFieldColor => const  Color(0xffF2F2F2);
  static Color get chatCloseContainerColor =>   Colors.white;
  static Color get timeColor =>   const Color(0xff828282);
  static Color get chatMicContainerColor => const  Color(0xffF2F2F2);
  static Color get timelineSegmentColor => const  Color(0xffBD0473);
}