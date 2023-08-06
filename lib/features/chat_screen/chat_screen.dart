import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text_audio_chat/features/chat_screen/providers/chat%20_state_manager.dart';
import 'package:text_audio_chat/features/chat_screen/widgets/own_message_bubble.dart';
import 'package:text_audio_chat/features/chat_screen/widgets/receiver_messages_bubble.dart';

import '../../core/constants/colors.dart';
import 'model/MessageModel.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ///audio waves

  @override
  void initState() {
    context.read<ChatStateManage>().askMicPermission();
    context.read<ChatStateManage>().initialiseControllers();
    // context.read<ChatStateManage>().scrollController.addListener(() {
    // });
    super.initState();
  }

  @override
  void dispose() {
    context.read<ChatStateManage>().recorderController.dispose();
    context.read<ChatStateManage>().scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14.0,
                ).copyWith(top: 16),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("MESSAGES",
                        style: TextStyle(
                          fontSize: 16,
                          letterSpacing: 3,
                          fontWeight: FontWeight.bold,
                        )),
                    Icon(
                      Icons.menu_rounded,
                      color: Colors.transparent,
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColor.primaryColor,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    const Text(
                      "Popular",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ListView.builder(
                    shrinkWrap: true,
                    // reverse: true,
                    controller:
                        context.read<ChatStateManage>().scrollController,
                    itemCount: context.read<ChatStateManage>().messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      final message =
                          context.read<ChatStateManage>().messages[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: message.type == MessageType.own
                            ? OwnMessageBubble(message: message)
                            : ReceiverMessageBubble(message: message),
                      );
                    },
                  ),
                ),
              ),
              _buildTextField(),
            ],
          ),
        ),
      ),
    );
  }

  _buildTextField() {
    ChatStateManage watchChat = context.watch<ChatStateManage>();
    ChatStateManage readChat = context.watch<ChatStateManage>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Row(
        children: [
          if (watchChat.isRecording || watchChat.isRecordingCompleted)
            GestureDetector(
              onTap: () {
                watchChat.isRecording
                    ? readChat.cancelRecording()
                    : readChat.closeRecorder();
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.red.withOpacity(.2),
                child: const Icon(
                  color: Colors.white,
                  Icons.close,
                  size: 18,
                ),
              ),
            ),
          const SizedBox(
            width: 16,
          ),
          GestureDetector(
            onTap: readChat.startOrStopRecording,
            child: CircleAvatar(
              backgroundColor: watchChat.isRecording
                  ? AppColor.primaryColor.withOpacity(.2)
                  : AppColor.chatMicContainerColor,
              radius: 18,
              child: Icon(
                watchChat.isRecording
                    ? Icons.stop
                    : watchChat.isRecordingCompleted
                        ? Icons.check
                        : Icons.mic,
                color: Colors.grey,
                size: 18,
              ),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Flexible(
            child: Stack(
                alignment: Alignment.centerRight,
                clipBehavior: Clip.none,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: watchChat.isRecording
                        ? AudioWaveforms(
                            key: const Key("audio"),
                            enableGesture: true,
                            size: const Size(double.infinity, 50),
                            recorderController: readChat.recorderController,
                            waveStyle: WaveStyle(
                              waveColor: AppColor.primaryColor,
                              extendWaveform: true,
                              showMiddleLine: false,
                              scaleFactor: 100,
                              waveThickness: 2,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.only(left: 4),
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                          )
                        : watchChat.isRecordingCompleted
                            ? const SizedBox(
                                width: double.infinity,
                                child: Text("audio recorded"),
                              )
                            : Container(
                                color: Colors.transparent,
                                key: const Key("message"),
                                // height: 40,
                                child: TextField(
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.black),
                                  maxLines: 3,
                                  minLines: 1,
                                  controller: readChat.messageController,
                                  decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 8),
                                      filled: true,
                                      fillColor: AppColor.chatTextFieldColor,
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(24),
                                          borderSide: const BorderSide(
                                            color: Colors.transparent,
                                          )),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(24),
                                          borderSide: const BorderSide(
                                            color: Colors.transparent,
                                          )),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      // border: InputBorder.none,
                                      hintText: 'Type a message...',
                                      hintStyle: const TextStyle(fontSize: 10)),
                                ),
                              ),
                  ),
                  Positioned(
                    right: -6,
                    child: GestureDetector(
                      onTap: () {
                        readChat.sendMessage();
                      },
                      child: Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(0, 8),
                                  blurRadius: 22,
                                  color: const Color(0xff29273A)
                                      .withOpacity(0.21)),
                            ],
                            gradient: const LinearGradient(
                                transform: GradientRotation(0),
                                colors: [Color(0xff00B9A0), Color(0xff2B6F5A)]),
                            shape: BoxShape.circle),
                        child: const Padding(
                          padding: EdgeInsets.only(left: 2),
                          child: Icon(
                            Icons.send,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ]),
          ),
          const SizedBox(
            width: 24,
          ),
        ],
      ),
    );
  }
}
