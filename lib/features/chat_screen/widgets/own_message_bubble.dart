import 'package:flutter/material.dart';
import 'package:text_audio_chat/core/utils.dart';
import 'package:text_audio_chat/features/chat_screen/widgets/voice_message_buble.dart';

import '../../../core/constants/colors.dart';
import '../model/MessageModel.dart';


class OwnMessageBubble extends StatelessWidget {
  final ChatMessageModel message;

  const OwnMessageBubble({
    required this.message,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Text(
                  message.dateTime.getTime(),
                  style: TextStyle(color: AppColor.timeColor),
                ),
              ),
            ],
          ),
          Wrap(
            alignment: WrapAlignment.start,
            children: [
              message.messageFormat == MessageFormat.text
                  ? Container(
                      padding: const EdgeInsets.all(10),
                      constraints: BoxConstraints(
                          // minWidth: 50,
                          maxWidth: MediaQuery.of(context).size.width * 0.5),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(24),
                            topLeft: Radius.circular(24),
                            bottomLeft: Radius.circular(24)),
                        color: (AppColor.chatBubbleReceiverColor),
                      ),
                      child: Text(
                        message.message,
                        textAlign: TextAlign.left,
                        style: const TextStyle(color: Colors.white),
                        textWidthBasis: TextWidthBasis.longestLine,
                        softWrap: true,
                      ),
                    )
                  : VoiceMessageBubble(messageModel: message),
            ],
          ),
        ],
      ),
    );
  }
}


