import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text_audio_chat/features/chat_screen/providers/voice_state.dart';
import '../../../core/constants/colors.dart';
import '../model/MessageModel.dart';

class VoiceMessageBubble extends StatefulWidget {
  final ChatMessageModel messageModel;

  const VoiceMessageBubble({required this.messageModel, Key? key})
      : super(key: key);

  @override
  State<VoiceMessageBubble> createState() => _VoiceMessageBubbleState();
}

class _VoiceMessageBubbleState extends State<VoiceMessageBubble> {
  late PlayerController _playerController;

  @override
  void initState() {
    _playerController = PlayerController();
    context
        .read<VoiceState>()
        .prepareWaves(_playerController, widget.messageModel.message);
    super.initState();
  }

  @override
  void dispose() {
    // context.read<VoiceState>(). playerStateSubscription.cancel();
    // context.read<VoiceState>().playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key(DateTime.now().millisecond.toString()),
      // width: 60.w,
      decoration: widget.messageModel.type == MessageType.own
          ? BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(24),
                  topLeft: Radius.circular(24),
                  bottomLeft: Radius.circular(24)),
              color: (AppColor.chatBubbleReceiverColor),
            )
          : BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(24),
                  topLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24)),
              color: (AppColor.chatBubbleOwnColor),
            ),
      child: Padding(
        padding: const EdgeInsets.all(8.0).copyWith(left: 24),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Builder(builder: (context) {
              return AudioFileWaveforms(
                size: const Size(50, 40.0),
                continuousWaveform: true,
                playerController: context.read<VoiceState>().playerController,
                enableSeekGesture: true,
                waveformType: WaveformType.fitWidth,
                waveformData: const [],
                playerWaveStyle: const PlayerWaveStyle(
                  waveThickness: 2,
                  seekLineColor: Colors.red,
                  scaleFactor: 200,
                  fixedWaveColor: Colors.white,
                  liveWaveColor: Colors.black,
                  showSeekLine: true,
                  spacing: 3,
                ),
              );
            }),
            const SizedBox(
              width: 12,
            ),
            if (context.watch<VoiceState>().totalDuration != "00:00")
              Text(
                context.watch<VoiceState>().totalDuration.toString(),
                style: TextStyle(
                  color: widget.messageModel.type == MessageType.own
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            const SizedBox(
              width: 12,
            ),
            GestureDetector(
              onTap: () {
                context.read<VoiceState>().startPlaying();
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 12,
                child: Icon(
                  context
                          .read<VoiceState>()
                          .playerController
                          .playerState
                          .isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                  color: AppColor.primaryColor,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
