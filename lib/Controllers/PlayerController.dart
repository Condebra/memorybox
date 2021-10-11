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
  BehaviorSubject _streamControllerAudioState =
      BehaviorSubject<PlayerState>();

  Stream get playerStream => _streamControllerAudioState.stream;
  AudioItem _currentItem;
  bool _loading;
  bool playing;
  AudioPlayerState _playerState;

  List<AudioItem> queue = [];
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
      if(_finding == null || !_finding)_currentDuration = p;
      setState();
    });

    ///Status
    _audioPlayer.onPlayerStateChanged.listen((AudioPlayerState s)async {
      if(s == AudioPlayerState.COMPLETED){
        _currentDuration = _maxDuration;
      }
      if(s == AudioPlayerState.COMPLETED){
        queue.removeAt(0);
        if(queue.isNotEmpty){
         await _play(queue.first);
        }
      }else{

      }
      _playerState = s;
      setState();
    });
    _audioPlayer.onPlayerCompletion.listen((event) {
      playing = false;
      setState();
    });
  }
  openBig(){
    _playerBig = true;
    setState();
  }
  closeBig(){
    _playerBig = false;
    setState();
  }


  play(List<AudioItem> list)async{
    List<AudioItem> step = [];
    for(int i = 0; i < list.length; i++){
      step.add(list[i]);
    }
    stop();
    queue = step;
    _play(queue.first);
  }

  _play(AudioItem item) async {
    print("play ${item.pathAudio}");

    int result = await _audioPlayer.play(item.pathAudio);
    if (result == 1) {
      _currentItem = item;
      playing = true;
      _loading = true;
    }else{
      playing = false;
    }
    setState();
  }

  pause(){
    _audioPlayer.pause();
  }

  stop(){
    playing = false;
    _audioPlayer.stop();
  }

  resume(){
    _audioPlayer.resume();
  }
  next(){
    if(queue.isEmpty)stop();else {
      queue.removeAt(0);
      if(queue.isNotEmpty) {
        _play(queue[0]);
      }else{
        stop();
      }
    }
  }

  seek(Duration duration){
    _finding = false;
    _currentDuration = duration;
    _audioPlayer.seek(duration);
  }

  setDuration(Duration duration){
    _finding  = true;
    _currentDuration = duration;
    setState();
  }

  setHide(bool setHide){
    playing  = setHide;
    setState();
  }


  tapButton(AudioItem item){
    if(playing != null&& _playerState != null&& _currentItem != null&&playing && _playerState == AudioPlayerState.PLAYING && _currentItem.id == item.id){
      pause();
    }else{
      if(playing != null&& _playerState != null&& _currentItem != null&&_playerState ==  AudioPlayerState.PAUSED && _currentItem.id == item.id){
        resume();
      }else{
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
      current: _currentDuration, playerBig: _playerBig,
    );
    _streamControllerAudioState.sink.add(state);
    print(state.toString());
  }

  dispose() {
    _streamControllerAudioState.close();
  }
}
