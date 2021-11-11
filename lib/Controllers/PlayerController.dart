import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:recorder/Controllers/States/PlayerState.dart';
import 'package:recorder/UI/Player.dart';
import 'package:recorder/models/AudioModel.dart';
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
      if (state == AudioPlayerState.COMPLETED) {
        _currentDuration = _maxDuration;
        if (queue.length > 1) next();
      }
      // if (s == AudioPlayerState.COMPLETED) {
        // print(s);
        // if (currentPosition < queue.length)
        //   currentPosition++;
        // queue.removeAt(0);
        // if (queue.isNotEmpty) {
        // if (queue.isNotEmpty || currentPosition >= 0 && queue[currentPosition] != null) {
        //   // await _play(queue.first);
        //   await _play(queue[currentPosition]);
        // }
      // } else {}
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
    if (repeat) {
      for (int i = 0; i < 1000; i++)
        queue.addAll(list);
    }
    else queue.addAll(list);
    print("=queue=${queue.toString()}=queue=");
    await _play(queue[currentPosition]);
    for (int i = 1; i < queue.length; i++) {
      currentPosition = i;
      await _play(queue[currentPosition]);
    }
  }

  _play(AudioItem item) async {
    print("play ${item.toMap()}");

    int result = await _audioPlayer.play(item.pathAudio);
    if (result == 1) {
      _currentItem = item;
      playing = true;
      _loading = true;
    } else {
      playing = false;
    }
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
    print("NEXT() $currentPosition, ${queue.length}");
    if (queue.isNotEmpty && currentPosition > -1 && currentPosition < queue.length)
      _play(queue[currentPosition]);
    else {
      stop();
      // // queue.removeAt(0);
      // currentPosition++;
      // if (queue.isNotEmpty && currentPosition < queue.length) {
      //   _play(queue[currentPosition]);
      //   // _play(queue[0]);
      // } else {
      //   stop();
      // }
    }
  }

  prev() {
    // if (queue.isEmpty)
      stop();
    // else {
      _play(queue.first);
    // }
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
