import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../model/MessageModel.dart';

class ChatStateManage with ChangeNotifier, DiagnosticableTreeMixin {
  bool _isRecording = false;
  bool _isRecordingCompleted = false;

  String? audioFilePath;
  String? playBackAudioPath;

  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  late RecorderController recorderController;

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

  bool get isRecording => _isRecording;

  set isRecording(bool value) {
    _isRecording = value;
    notifyListeners();
  }

  /// functions
  void initialiseControllers() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..updateFrequency = const Duration(milliseconds: 50)
      ..sampleRate = 44100
      ..bitRate = 48000;
  }

  void askMicPermission() async {
    await Permission.microphone.request();
  }

  void startOrStopRecording() async {

    try {
      recorderController.refresh();
      recorderController.reset();
      if (_isRecording) {

        final path = await recorderController.stop(false);
        if (path != null) {
          _isRecordingCompleted = true;
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
      _isRecording = !_isRecording;
      notifyListeners();
    }
  }

  void cancelRecording() {
    recorderController.stop();
    _isRecording = false;
    notifyListeners();
  }

  void closeRecorder() {
    _isRecording = false;
    _isRecordingCompleted = false;
    //Todo delete function for the files
    notifyListeners();
  }

  void sendMessage() {
    if (playBackAudioPath != null) {
      // _messages.reversed;
      _messages.add(ChatMessageModel(
          messageFormat: MessageFormat.audio,
          message: playBackAudioPath!,
          type: MessageType.own,
          dateTime: DateTime.now()));
      _isRecordingCompleted = false;
      notifyListeners();
    }

    if (messageController.text.isNotEmpty) {
      _messages.add(ChatMessageModel(
          messageFormat: MessageFormat.text,
          message: messageController.text,
          type: MessageType.own,
          dateTime: DateTime.now()));
      messageController.clear();
      playBackAudioPath = null;
      notifyListeners();
    }

    scrollController.animateTo(
      0,
      // scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  bool get isRecordingCompleted => _isRecordingCompleted;

  set isRecordingCompleted(bool value) {
    _isRecordingCompleted = value;
    notifyListeners();
  }

  List<ChatMessageModel> get messages => _messages;

// set messages(List<ChatMessageModel> value) {
//   _messages = value;
//   // notifyListeners();
// }
}
