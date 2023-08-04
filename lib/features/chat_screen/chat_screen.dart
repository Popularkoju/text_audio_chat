import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
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
  // final List<ChatMessageModel> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final List<ChatMessageModel> _messages = [
    ChatMessageModel(
        message: "Hello",
        dateTime: DateTime.now(),
        type: MessageType.receiver,
        messageFormat: MessageFormat.text),
    ChatMessageModel(
        message: "hey",
        dateTime: DateTime.now(),
        type: MessageType.own,
        messageFormat: MessageFormat.text),
    ChatMessageModel(
        message: "Can you teach me to  create chat ui in flutter?",
        dateTime: DateTime.now(),
        type: MessageType.receiver,
        messageFormat: MessageFormat.text),
    ChatMessageModel(
        message: "yeah, sure",
        dateTime: DateTime.now(),
        type: MessageType.own,
        messageFormat: MessageFormat.text),
    ChatMessageModel(
        message:
            "I want to create adaptive chat box along with the voice chat. Can you help me out?",
        dateTime: DateTime.now(),
        type: MessageType.receiver,
        messageFormat: MessageFormat.text),
    // ChatMessageModel(
    //     message:
    //     "Lets get started?",
    //     dateTime: DateTime.now(),
    //     type: MessageType.own,
    //     messageFormat: MessageFormat.text)
  ];

  ///audio waves
  late final RecorderController recorderController;

  bool isRecording = false;
  bool isRecordingCompleted = false;

  @override
  void initState() {
    _askMicPermission();
    _initialiseControllers();
    scrollController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    recorderController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  String? audioFilePath;
  String? playBackAudioPath;

  void _initialiseControllers() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..updateFrequency = const Duration(milliseconds: 50)
      ..sampleRate = 44100
      ..bitRate = 48000;
  }

  _askMicPermission() async {
    await Permission.microphone.request();
  }

  void _sendMessage({String? message}) {
    if (playBackAudioPath != null) {
      _messages.add(ChatMessageModel(
          messageFormat: MessageFormat.audio,
          message: playBackAudioPath!,
          type: MessageType.own,
          dateTime: DateTime.now()));
      playBackAudioPath = null;
    }

    if (message != null && message.isNotEmpty) {
      _messages.add(ChatMessageModel(
          messageFormat: MessageFormat.text,
          message: message,
          type: MessageType.own,
          dateTime: DateTime.now()));
      _messageController.clear();
      playBackAudioPath = null;
    }

    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    isRecordingCompleted = false;
    setState(() {});
  }

  void _startOrStopRecording() async {
    try {
      if (isRecording) {
        recorderController.reset();
        final path = await recorderController.stop(false);
        if (path != null) {
          isRecordingCompleted = true;
          playBackAudioPath = path;
          debugPrint(path);
          debugPrint("Recorded file size: ${File(path).lengthSync()}");
        }
      } else {
        final Directory tempDir = await getTemporaryDirectory();
        audioFilePath = tempDir.path;
        await recorderController.record(
            path:
                "$audioFilePath/chat${DateTime.now().toString().replaceAll(" ", "_").replaceAll(":", "_").replaceAll(".", "_")}.aac");
        // omit : whitespaces to file name otherwise error occurs when recording
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void cancelRecording() {
    recorderController.stop();
    setState(() {
      isRecording = false;
    });
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
                    controller: scrollController,
                    itemCount: _messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      final message = _messages[index];
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Row(
        children: [
          if (isRecording || isRecordingCompleted)
            GestureDetector(
              onTap: () {
                cancelRecording();
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: Icon(
                  color: Colors.grey.shade300,
                  Icons.close,
                  size: 18,
                ),
              ),
            ),
          const SizedBox(
            width: 16,
          ),
          GestureDetector(
            onTap: _startOrStopRecording,
            child: CircleAvatar(
              backgroundColor: isRecording
                  ? AppColor.primaryColor.withOpacity(.2)
                  : AppColor.chatMicContainerColor,
              radius: 18,
              child: Icon(
                isRecording
                    ? Icons.pause
                    : isRecordingCompleted
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
                    child: isRecording
                        ? AudioWaveforms(
                            key: const Key("audio"),
                            enableGesture: true,
                            size: const Size(double.infinity, 50),
                            recorderController: recorderController,
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
                        : isRecordingCompleted
                            ? Container(
                                width: double.infinity,
                                child: const Text(
                                    "Press send button to send audio"),
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
                                  controller: _messageController,
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
                        _sendMessage(message: _messageController.text);
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
