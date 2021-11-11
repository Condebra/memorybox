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
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StateSearch {
  final String input;
  final List<AudioItem> results;

  StateSearch({@required this.input, @required this.results});
}

class CollectionsController {
  CollectionStates _state;
  CollectionStates _previousState;
  List<CollectionItem> itemsCollection;
  CollectionItem _currentItem;
  List<AudioItem> _audios;
  List<AudioItem> audiosAll;
  List<AudioItem> _audiosSearch;
  Function update;
  bool _edit;
  String input = "";
  List<AudioItem> results = [];

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
    _state = CollectionStates.loading;
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

  selectAudio(AudioItem item, int index) {
    // for (int i = 0; i < audiosAll.length; i++) {
    //   if (audiosAll[i].id == null
    //       ? audiosAll[i].idS == item.idS
    //       : audiosAll[i].id == item.id) {
    //     if (audiosAll[i].select != null && audiosAll[i].select) {
    //       audiosAll[i].select = false;
    //     } else {
    //       audiosAll[i].select = true;
    //     }
    //   }
    // }
    // audiosAll.forEach((element) {
    //   if (element.id == null ? element.idS == item.idS : element.id == item.id)
    //   if (element.select != null)
    //     element.select = !element.select;
    //   else element.select = true;
    // });
    if (audiosAll[index].select != null)
      audiosAll[index].select = !audiosAll[index].select;
    else audiosAll[index].select = true;
    _search();
    setState();
  }

  setCollections(List<CollectionItem> items) {
    itemsCollection = items;
    _state = CollectionStates.view;
    setState();
  }

  setAudios(List<AudioItem> audios) {
    audiosAll = audios;
    setState();
  }

  addCollection() async {
    _audios = [];
    controllerHeader.text = "";
    controllerComment.text = "";
    _previousState = CollectionStates.add;
    _state = CollectionStates.add;
    setState();
  }

  addAudio() {
    _audios = [];
    _state = CollectionStates.addAudio;
    setState();
  }

  edit({CollectionItem item}) {
    if (item != null) _currentItem = item;
    controllerHeader.text = _currentItem.name;
    controllerComment.text = _currentItem.description;
    _previousState = CollectionStates.editing;
    _state = CollectionStates.editing;
    setState();
  }

  view(CollectionItem item) async {
    // print(item.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("playlist", item.id);
    _state = CollectionStates.loading;
    setState();

    _currentItem = item;
    print("=============================================="
        "\n${_currentItem.toMap().toString()}");
    if (_currentItem.playlist == null)
      _currentItem.playlist =
          await PlaylistProvider.getAudioFromId(idS: item.idS);
    _state = CollectionStates.viewItem;
    setState();
  }

  back() async {
    switch (_state) {
      case CollectionStates.addAudio:
        _audios.clear();
        audiosAll.forEach((element) {
          if (element.select != null && element.select) _audios.add(element);
        });
        if (_previousState == CollectionStates.editing)
          _state = CollectionStates.editing;
        if (_previousState == CollectionStates.add)
          _state = CollectionStates.add;
        _previousState = CollectionStates.addAudio;
        // _state = CollectionStates.add;
        setState();
        break;
      case CollectionStates.add:
        _audios.clear();
        audiosAll.forEach((element) {element.select = false;});
        _previousState = CollectionStates.add;
        _state = CollectionStates.view;
        setState();
        break;
      case CollectionStates.editing:
        _pathPhoto = null;
        _previousState = CollectionStates.editing;
        _state = CollectionStates.viewItem;
        setState();
        break;
      case CollectionStates.viewItem:
        _previousState = CollectionStates.viewItem;
        _state = CollectionStates.view;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt("playlist", 0);
        setState();
        break;
      case CollectionStates.select:
        print("CollectionState.select");
        _previousState = CollectionStates.select;
        _state = CollectionStates.viewItem;
        setState();
        break;
      default:
        _state = CollectionStates.view;
        setState();
    }
  }

  createCollection() async {
    if (controllerHeader.text.isNotEmpty) {
      if (controllerComment.text.isNotEmpty) {
        _state = CollectionStates.loading;
        setState();
        int response = await PlaylistProvider.create(
            controllerHeader.text, controllerComment.text, _pathPhoto);
        _state = CollectionStates.add;
        setState();
        for (int i = 0; i < _audios.length; i++) {
          await PlaylistProvider.addAudioToPlaylist(
              response, _audios[i].id ?? _audios[i].idS,
              isLocalPlaylist: true, isLocalAudio: _audios[i].id != null);
        }
        controllerComment.text = "";
        controllerHeader.text = "";
        _pathPhoto = null;
        update();
        back();
      } else {
        showDialogIntegronError(AppKeys.scaffoldKey.currentContext,
            "Некорректное описание плейлиста");
      }
    } else {
      showDialogIntegronError(AppKeys.scaffoldKey.currentContext,
          "Некорректное название плейлиста");
    }
  }

  selectSeveral() {
    audiosAll.forEach((element) {
      element.select = false;
    });
    _state = CollectionStates.select;
    setState();
  }

  addToPlaylistSelect(GeneralController generalController) {
    List<AudioItem> selected = [];
    audiosAll.forEach((element) {
      if (element.select) selected.add(element);
    });
    if (selected.isNotEmpty) {
      addToPlaylist(selected, generalController);
    }
  }

  deleteSelectAudio(RestoreController restoreController) async {
    List<AudioItem> selected = [];
    audiosAll.forEach((element) {
      element.select ? selected.add(element) : null;
    });
    if (selected.isNotEmpty) {
      await restoreController.deleteSeveral(
        selected,
      );
    }
    updateData();
  }

  backAndSave() async {
    showDialogLoading(AppKeys.scaffoldKey.currentContext);
    String c = controllerComment.text;
    String n = controllerHeader.text;
    await PlaylistProvider.edit(_currentItem.id,
        imagePath: _pathPhoto, desc: c, name: n);
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

  deleteCurrent() async {
    _state = CollectionStates.loading;
    setState();
    if (_currentItem.id != null) {
      await PlaylistProvider.deleteLocal(_currentItem.id);
    }
    if (_currentItem.idS != null) {
      await PlaylistProvider.deleteS(_currentItem.idS);
    }
    update();
  }

  searchClean() {
    input = "";
    results = [];
    setState();
  }

  search(String input) {
    if (input.isEmpty) {
      results = List.from(audiosAll);
    } else {
      List<AudioItem> out = [];
      audiosAll.forEach((element) {
        if (element.name.toLowerCase().contains(input.toLowerCase()) ||
            element.description.toLowerCase().contains(input.toLowerCase())) {
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
        stateSelect: _state,
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
