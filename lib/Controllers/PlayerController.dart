import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:recorder/Controllers/States/PlayerState.dart';
import 'package:recorder/models/AudioItem.dart';
import 'package:rxdart/rxdart.dart';

class PlayerController {
  AudioPlayer _audioPlayer = AudioPlayer();

  Duration _currentDuration;
  Duration _maxDuration;

  bool _finding;
  BehaviorSubject _streamControllerAudioState = BehaviorSubject<PlayerState>();

  Stream get playerStream => _streamControllerAudioState.stream;
  AudioItem _currentItem;
  bool _loading;
  bool playing;
  AudioPlayerState _playerState;

  List<AudioItem> queue = [];
  int currentPosition = -1;
  bool _playerBig = false;

  PlayerController() {
    ///MAX
    _audioPlayer.onDurationChanged.listen((Duration d) {
      _loading = false;
      _maxDuration = d;
      setState();
    });

    ///Current
    _audioPlayer.onAudioPositionChanged.listen((Duration p) {
      if (_finding == null || !_finding) _currentDuration = p;
      setState();
    });

    ///Status
    _audioPlayer.onPlayerStateChanged.listen((AudioPlayerState state) async {
      print(state);
      if (state == AudioPlayerState.COMPLETED)
        _currentDuration = _maxDuration;
      // print("CURRENT POSITION => $currentPosition");
      if (state == AudioPlayerState.COMPLETED) {
        // print(state);
        if (currentPosition < queue.length - 1) {
          currentPosition++;
          _play(queue[currentPosition]);
        }
        // print("CURRENT POSITION $currentPosition");
      }
      _playerState = state;
      setState();
    });
    _audioPlayer.onPlayerCompletion.listen((event) {
      playing = false;
      setState();
    });
  }

  openBig() {
    _playerBig = true;
    setState();
  }

  closeBig() {
    _playerBig = false;
    setState();
  }

  play(List<AudioItem> list, {bool repeat = false}) async {
    stop();
    queue.clear(); //немного костыльно
    currentPosition = 0;
    print("LIST LENGTH ${list.length}");
    if (repeat)
      for (int i = 0; i < 10000; i++) //ещё немного костылирования
        queue.addAll(list);
    else queue.addAll(list);
    // print("=queue=${queue.toString()}=queue=");
    await _play(queue[currentPosition]);
  }

  _play(AudioItem item) async {
    // print("play ${item.toMap()}");
    int result = await _audioPlayer.play(item.pathAudio);
    if (result == 1) {
      _currentItem = item;
      playing = true;
      _loading = true;
    } else
      playing = false;
    setState();
  }

  pause() {
    _audioPlayer.pause();
  }

  stop() {
    playing = false;
    _audioPlayer.stop();
  }

  resume() {
    _audioPlayer.resume();
  }

  next() {
    // print("NEXT() $currentPosition, ${queue.length}");
    currentPosition++;
    if (queue.isNotEmpty && currentPosition > -1 && currentPosition < queue.length)
      _play(queue[currentPosition]);
    else {
      stop();
    }
  }

  prev() {
    // print("PREV() $currentPosition, ${queue.length}");
    currentPosition--;
    if (queue.isNotEmpty && currentPosition > -1 && currentPosition < queue.length)
      _play(queue[currentPosition]);
    else
      stop();
  }

  seek(Duration duration) {
    _finding = false;
    _currentDuration = duration;
    _audioPlayer.seek(duration);
  }

  setDuration(Duration duration) {
    _finding = true;
    _currentDuration = duration;
    setState();
  }

  setHide(bool setHide) {
    playing = setHide;
    setState();
  }

  tapButton(AudioItem item) {
    if (playing != null &&
        _playerState != null &&
        _currentItem != null &&
        playing &&
        _playerState == AudioPlayerState.PLAYING &&
        _currentItem.id == item.id) {
      pause();
    } else {
      if (playing != null &&
          _playerState != null &&
          _currentItem != null &&
          _playerState == AudioPlayerState.PAUSED &&
          _currentItem.id == item.id) {
        resume();
      } else {
        play([item]);
      }
    }
  }

  setState() {
    PlayerState state = PlayerState(
      max: _maxDuration,
      loading: _loading,
      playing: playing,
      item: _currentItem,
      state: _playerState,
      current: _currentDuration,
      playerBig: _playerBig,
    );
    _streamControllerAudioState.sink.add(state);
    // print(state.toString());
  }

  dispose() {
    _streamControllerAudioState.close();
  }
}
