import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recorder/Controllers/GeneralController.dart';
import 'package:recorder/Controllers/RestoreController.dart';
import 'package:recorder/Controllers/States/CollectionsState.dart';
import 'package:recorder/Rest/Playlist/PlaylistProvider.dart';
import 'package:recorder/UI/AddToPlaylist.dart';
import 'package:recorder/Utils/DialogsIntegron/DialogIntegron.dart';
import 'package:recorder/Utils/DialogsIntegron/DialogLoading.dart';
import 'package:recorder/Utils/app_keys.dart';
import 'package:recorder/models/AudioModel.dart';
import 'package:recorder/models/CollectionModel.dart';
import 'package:recorder/models/Put.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';


class StateSearch{
  final String input;
  final List<AudioItem> results;

  StateSearch({
    @required this.input,
    @required this.results
  });
}

class CollectionsController {
  CollectionsSelection _stateSelect;
  List<CollectionItem> itemsCollection;
  CollectionItem _currentItem;
  List<AudioItem> _audios;
  List<AudioItem> audiosAll;
  List<AudioItem> _audiosSearch;
  Function update;
  bool _edit;
  String input = "";
  List<AudioItem> results =[];


  final _picker = ImagePicker();
  TextEditingController controllerHeader = TextEditingController();
  TextEditingController controllerComment = TextEditingController();
  TextEditingController controllerSearch = TextEditingController();
  String _pathPhoto;

  BehaviorSubject _behaviorSubject = BehaviorSubject<CollectionsState>();
  BehaviorSubject _behaviorSubjectPhoto = BehaviorSubject<String>();
  BehaviorSubject _behaviorSubjectSearch = BehaviorSubject<StateSearch>();

  get streamCollections => _behaviorSubject.stream;
  get streamPhoto => _behaviorSubjectPhoto.stream;
  get streamSearch => _behaviorSubjectSearch.stream;

  CollectionsController(this.update) {
    _audiosSearch = [];
    _stateSelect = CollectionsSelection.loading;
    setState();
    controllerSearch.addListener(() {
      _search();
    });
  }

  updateData() {
    update();
  }

  _search() {
    _audiosSearch = [];
    for (int i = 0; i < audiosAll.length; i++) {
      RegExp exp = new RegExp(controllerSearch.text.toLowerCase());
      String str = audiosAll[i].name.toLowerCase();
      String str2 = audiosAll[i].description.toLowerCase();
      if (exp.hasMatch(str) || exp.hasMatch(str2)) {
        _audiosSearch.add(audiosAll[i]);
      }
    }
    setState();
  }

  selectAudio(AudioItem item) {
    for (int i = 0; i < audiosAll.length; i++) {
      if (audiosAll[i].id == null ? audiosAll[i].idS == item.idS : audiosAll[i].id==item.id) {
        if (audiosAll[i].select != null && audiosAll[i].select) {
          audiosAll[i].select = false;
        } else {
          audiosAll[i].select = true;
        }
      }
    }
    _search();
    setState();
  }

  setCollections(List<CollectionItem> items) {
    itemsCollection = items;
    _stateSelect = CollectionsSelection.view;
    setState();
  }

  setAudios(List<AudioItem> audios) {
    audiosAll = audios;
    setState();
  }

  addCollection() async {
    _audios = [];
    _stateSelect = CollectionsSelection.add;
    setState();
  }

  addAudio() {
    _stateSelect = CollectionsSelection.addAudio;
    setState();
  }

  edit({CollectionItem item}) {
    if (item != null) _currentItem = item;
    controllerHeader.text = _currentItem.name;
    controllerComment.text = _currentItem.description;
    _stateSelect = CollectionsSelection.editing;
    setState();
  }

  view(CollectionItem item) async {
    print(item.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("playlist", item.id);
    _stateSelect = CollectionsSelection.loading;
    setState();

    _currentItem = item;
    print("=============================================="
        "\n${_currentItem.toMap().toString()}");
    if (_currentItem.playlist == null)
      _currentItem.playlist = await PlaylistProvider.getAudioFromId(idS: item.idS);
    _stateSelect = CollectionsSelection.viewItem;
    setState();
  }

  back() async {
    if (_stateSelect == CollectionsSelection.addAudio) {
      _audios = [];
      for (int i = 0; i < audiosAll.length; i++)
        if (audiosAll[i].select != null && audiosAll[i].select)
          _audios.add(audiosAll[i]);

      // print(_audios.length);
      _stateSelect = CollectionsSelection.add;
      setState();
    } else if (_stateSelect == CollectionsSelection.add) {
      _audios = [];
      _stateSelect = CollectionsSelection.view;
      setState();
    } else if (_stateSelect == CollectionsSelection.editing) {
      _pathPhoto = null;
      _stateSelect = CollectionsSelection.viewItem;
      setState();
    } else if (_stateSelect == CollectionsSelection.viewItem) {
      _currentItem = null;
      _stateSelect = CollectionsSelection.view;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt("playlist", 0);
      setState();
    } else if(_stateSelect == CollectionsSelection.select){
      _stateSelect = CollectionsSelection.viewItem;
      setState();
    }else {
      _stateSelect = CollectionsSelection.view;
      setState();
    }
  }

  createCollection() async {
    if (controllerHeader.text.isNotEmpty) {
      if (controllerComment.text.isNotEmpty) {
        if (true) {
          _stateSelect = CollectionsSelection.loading;
          setState();
          int response = await PlaylistProvider.create(
              controllerHeader.text, controllerComment.text, _pathPhoto);
          _stateSelect = CollectionsSelection.add;
          setState();
          for(int i = 0 ; i < _audios.length; i++) {
            await PlaylistProvider.addAudioToPlaylist(
                response, _audios[i].id??_audios[i].idS, isLocalPlaylist: true, isLocalAudio: _audios[i].id != null );
          }
          controllerComment.text = "";
          controllerHeader.text = "";
          _pathPhoto = null;
          update();

          back();

        } else {
          showDialogIntegronError(AppKeys.scaffoldKey.currentContext, "Выберите обложку плейлиста");
        }
      } else {
        showDialogIntegronError(AppKeys.scaffoldKey.currentContext, "Некорректное описание плейлиста");
      }
    } else {
      //todo  no name
      showDialogIntegronError(AppKeys.scaffoldKey.currentContext, "Некорректное название плейлиста");
    }
  }

  selectSeveral(){
    audiosAll.forEach((element) {element.select=false;});
    _stateSelect = CollectionsSelection.select;
    setState();
  }

  addToPlaylistSelect(GeneralController generalController) {
    List<AudioItem> selected = [];
    audiosAll.forEach((element) {element.select ? selected.add(element) : null;});
    if (selected.isNotEmpty) {
      addToPlaylist(selected, generalController);
    }
  }

  deleteSelectAudio(RestoreController restoreController) async {
    List<AudioItem> selected = [];
    audiosAll.forEach((element){element.select?selected.add(element):null;});
    if(selected.isNotEmpty){
      await restoreController.deleteSeveral(selected,);
    }
    updateData();
  }




  backAndSave() async {
    showDialogLoading(AppKeys.scaffoldKey.currentContext);
    String c;
    String n;
    if(controllerComment.text !=""){c= controllerComment.text;}
    if(controllerHeader.text != ""){n= controllerHeader.text;}
    await PlaylistProvider.edit(_currentItem.id, imagePath: _pathPhoto, desc: c,name: n);
    closeDialog(AppKeys.scaffoldKey.currentContext);
    back();
    update();
  }

  Future addImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _pathPhoto = (pickedFile.path);
    } else {
      print('No image selected.');
    }
    setState();
  }

  deleteCurrent()async{
    _stateSelect = CollectionsSelection.loading;
    setState();
    if(_currentItem.id != null){
      await PlaylistProvider.deleteLocal(_currentItem.id);
    }
    if(_currentItem.idS != null){
      await PlaylistProvider.deleteS(_currentItem.idS);
    }
    update();
  }

  searchClean(){
    input = "";
    results = [];
    setState();
  }
  search(String input){
    if(input.isEmpty){
      results = List.from(audiosAll);
    }else{
      List<AudioItem> out = [];
      audiosAll.forEach((element) {
        if(element.name.contains(input) || element.description.contains(input)){
          out.add(element);
        }
      });
      results = out;
    }
    setState();
  }

  setState() {
    StateSearch stateSearch = StateSearch(input: input, results: results);
    CollectionsState state = CollectionsState(
        audios: _audios,
        currentItem: _currentItem,
        items: itemsCollection,
        stateSelect: _stateSelect,
        audiosSearch: _audiosSearch,
        audiosAll: audiosAll);
    _behaviorSubject.sink.add(state);
    _behaviorSubjectPhoto.sink.add(_pathPhoto);
    _behaviorSubjectSearch.sink.add(stateSearch);
  }

  dispose() {
    _behaviorSubject.close();
    _behaviorSubjectPhoto.close();
    _behaviorSubjectSearch.close();
  }
}
