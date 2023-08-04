import 'dart:async';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:text_audio_chat/core/utils.dart';

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
   PlayerController playerController =PlayerController();

  late StreamSubscription<PlayerState> playerStateSubscription;

  String totalDuration = "00:00";
  final int _noOfSamples = 20;

  // bool isPlaying = false;

  @override
  void initState() {
    _prepareWaves();
    playerStateSubscription =
        playerController.onPlayerStateChanged.listen((playerState) {
      setState(() {});
    });
    super.initState();
  }

  _prepareWaves() async {
    await playerController.preparePlayer(
      path: widget.messageModel.message,
      shouldExtractWaveform: true,
      noOfSamples: _noOfSamples,
      volume: 1.0,
    );
    int duration = await playerController.getDuration();
    totalDuration = duration.toMinutesSecondsString();
    setState(() {});

    // await playerControllers
    //     .preparePlayer(
    //   path: a,
    //   shouldExtractWaveform: false,
    //   noOfSamples: 100,
    //   volume: 1.0,
    // )
    //     .then((value) async {
    //   int duration = await playerController.getDuration();
    //   totalDuration = duration.toMinutesSecondsString();
    // });
    // setState(() {});
  }

  _startPlaying() async {
    try {
      if (playerController.playerState.isPlaying) {
        await playerController.pausePlayer();
      } else {
        await playerController.startPlayer(finishMode: FinishMode.pause);
        // setState(() {});
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      // setState(() {
      //   isPlaying = !isPlaying;
      // });
      // playerController.dispose();
    }
  }

  @override
  void dispose() {
    playerStateSubscription.cancel();
    playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key(DateTime.now().millisecond.toString()),
      // width: 60.w,
      decoration: widget.messageModel.type == MessageType.own
          ? BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(24),
                  topLeft: Radius.circular(24),
                  bottomLeft: Radius.circular(24)),
              color: (AppColor.chatBubbleReceiverColor),
            )
          : BoxDecoration(
              borderRadius: BorderRadius.only(
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
            Builder(
              builder: (context) {
                return AudioFileWaveforms(
                  size: Size(50, 40.0),
                  continuousWaveform: true,
                  playerController: playerController,
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
              }
            ),
            SizedBox(
              width: 12,
            ),
            if (totalDuration != "00:00")
              Text(
                totalDuration.toString(),
                style: TextStyle(
                  color: widget.messageModel.type == MessageType.own
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            SizedBox(
              width: 12,
            ),
            GestureDetector(
              onTap: () {
                _startPlaying();
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 12,
                child: Icon(
                  playerController.playerState.isPlaying
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
