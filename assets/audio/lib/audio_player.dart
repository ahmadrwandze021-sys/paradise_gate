import 'package:audioplayers/audioplayers.dart';

class QuranAudioPlayer {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playSurah(int number) async {
    String path = "assets/audio/$number.mp3";

    await _player.stop();
    await _player.play(AssetSource(path));
  }

  static Future<void> stop() async {
    await _player.stop();
  }
}
