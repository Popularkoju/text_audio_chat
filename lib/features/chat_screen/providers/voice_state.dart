import 'dart:async';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:text_audio_chat/core/utils.dart';

class VoiceState with ChangeNotifier, DiagnosticableTreeMixin {
late  PlayerController playerController ;

  late StreamSubscription<PlayerState> playerStateSubscription;

  String _totalDuration = "00:00";

  String get totalDuration => _totalDuration;
  final int _noOfSamples = 20;

  void prepareWaves(PlayerController playerControllerFrom,String filePathToPlayAudio) async {
    playerController =playerControllerFrom;
    playerStateSubscription =
        playerController.onPlayerStateChanged.listen((playerState) {
      notifyListeners();
    });
    await playerController.preparePlayer(
      path: filePathToPlayAudio,
      shouldExtractWaveform: true,
      noOfSamples: _noOfSamples,
      volume: 1.0,
    );
    int duration = await playerController.getDuration();
    _totalDuration = duration.toMinutesSecondsString();
    notifyListeners();
  }

  startPlaying() async {
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

// @override
//   void dispose() {
//    playerController.dispose();
//    playerStateSubscription.cancel();
//     super.dispose();
//   }


}
