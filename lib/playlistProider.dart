import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mysong/songs_model.dart';

class PlatListProvider extends ChangeNotifier {
  final List<Songs> _playlist = [
    Songs(
        songName:
            'https://raag.fm/files/mp3/128/Hindi/1065309/Kya%20Khoob%20Lagti%20Ho%20-%20(Raag.Fm).mp3',
        photo: 'assets/images/image1.jpg'),
    Songs(
        songName:
            'https://raag.fm/files/mp3/128/Hindi/1051088/Tu%20Tu%20Hai%20Wahi%20-%20Yeh%20Vaada%20Raha%20-%20(Raag.Fm).mp3',
        photo:
            'assets/images/image2.jpg'),
    Songs(
        songName:
            'https://raag.fm/files/mp3/128/Hindi/1289782/Janu%20Meri%20Jaan%20(Shaan)%20-%20(Raag.Fm).mp3',
        photo: 'assets/images/image3.jpg'),
    Songs(
        songName:
            'https://raag.fm/files/mp3/128/Hindi/10359760/Rang%20Jo%20Lagyo%20(Ramaiya%20Vastavaiya)%20-%20(Raag.Fm).mp3',
        photo: 'assets/images/image4.jpg'),
    Songs(
        songName:
            'https://raag.fm/files/mp3/128/Hindi/1147194/Aankhon%20Mein%20Teri%20-%20(Raag.Fm).mp3',
        photo:
            'assets/images/image5.jpg'),
    Songs(
        songName:
            'https://raag.fm/files/mp3/128/Hindi-Singles/21356/Dil%20Ko%20Karaar%20Aaya%20(Reprise)%20-%20(Raag.Fm).mp3',
        photo:
            'assets/images/image6.jpg'),
    Songs(
        songName:
            'https://raag.fm/files/mp3/128/Hindi/1048971/Saathiyaa%20-%20(Raag.Fm).mp3',
        photo: 'assets/images/image7.jpg'),
    Songs(
        songName:
            'https://raag.fm/files/mp3/128/Hindi/1048277/Saibo%20-%20(Raag.Fm).mp3',
        photo:
            'assets/images/image8.jpg'),
    Songs(
        songName:
            'https://raag.fm/files/mp3/128/Hindi/1024386/Tere%20Mast%20Mast%20Do%20Nain%20-%20(Raag.Fm).mp3',
        photo: 'assets/images/image9.jpg')
  ];

  int _currentIndex = 0;
  int _seekValue = 0;
  bool _isplaying = false;
  int _photoIndex = 0;

  final AudioPlayer _audioPlayer = AudioPlayer();

  List<Songs> get playlist => _playlist;
  int get currentIndex => _currentIndex;
  int get seekValue => _seekValue;
  bool get isPlaying => _isplaying;
  int get photoIndex => _photoIndex;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void pauseAudio() async {
    _audioPlayer.pause();
  }

  void playAudio(String songname) async {
    try {
      if (_audioPlayer.playing) {
        await _audioPlayer.stop();
      }
      await _audioPlayer.setUrl(songname);
      await _audioPlayer.seek(Duration(seconds: seekValue));
      await _audioPlayer.play();
    } catch (PlatformException) {
      print("Platform Exception:");
    }
  }

  void forward10Seconds(newPosition) async {
    final currentPosition = await _audioPlayer.position;
    final newPosition = currentPosition + Duration(seconds: 10);
    await _audioPlayer.seek(newPosition);
  }

  void playPreviousSong(_currentIndex) {
    if (_currentIndex != null) {
      if (_currentIndex! > 0) {
        _currentIndex = _currentIndex! - 1;
      } else {
        _currentIndex = playlist.length - 1; // Loop back to the last song
      }
      playAudio(playlist[_currentIndex!].songName);
    }
  }

//setters

  set isPlaying(bool isPlaying) {
    _isplaying = isPlaying;
  }

  set seekValue(int value) {
    _seekValue = value;
  }

  set currentIndex(int index) {
    _currentIndex = index;
  }
}
