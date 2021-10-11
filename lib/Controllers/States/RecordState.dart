part of '../GeneralController.dart';
/*
0 - Не записывает
1 - записывает
2 - пауза
3 - стоп
 */



class RecordState{
  bool loading;
  RecordingStatus  status;
  List<int> power;
  int maxPower;
  AudioItem audio;
  Duration duration;
  PlayerState playerState;
  RecordState(this.status, this.power, this.duration, this.maxPower, {this.audio, this.playerState, this.loading});
}