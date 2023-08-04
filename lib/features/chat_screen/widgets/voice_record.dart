// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import '../../../../Constants/colors.dart';
//
// class VoiceRecord extends StatelessWidget {
//   final Function() startRecording;
//  final Function() stopRecording;
//
//   const VoiceRecord(this.startRecording, this.stopRecording, {Key? key})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onLongPressDown: (LongPressDownDetails detail) {
//         startRecording;
//       },
//       onLongPressEnd: (details) {
//         stopRecording;
//       },
//       child: CircleAvatar(
//         backgroundColor: AppColor.chatMicContainerColor,
//         radius: 18.r,
//         child: Icon(
//           Icons.mic,
//           color: AppColor.greyIconColor,
//           size: 18,
//         ),
//       ),
//     );
//   }
// }
