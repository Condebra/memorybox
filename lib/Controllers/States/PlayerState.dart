import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:recorder/models/AudioModel.dart';

class PlayerState{
  final bool playing;
  final bool playerBig;
  final Duration max;
  final Duration current;
  final loading;
  final AudioItem item;
  final AudioPlayerState state;

  PlayerState( {@required this.playing,@required  this.max, @required this.current, @required this.loading, @required this.item, @required this.state, @required this.playerBig,});

  @override
  String toString() {
    return "playing: ${this.playing.toString()} loading: ${this.loading.toString()} max: ${this.max.toString()} current: ${this.current.toString()} state: ${this.state.toString()} id: ";
  }
}