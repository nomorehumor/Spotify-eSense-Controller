import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';


Future<AudioHandler> initAudioService() async {
  return await AudioService.init(
    builder: () => AppAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.mycompany.myapp.audio',
      androidNotificationChannelName: 'Audio Service Demo',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );
}

class AppAudioHandler extends BaseAudioHandler {
  Future<void> play() => print("sdca");

}