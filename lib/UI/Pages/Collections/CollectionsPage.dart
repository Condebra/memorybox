import 'package:flutter/material.dart';
import 'package:recorder/Controllers/GeneralController.dart';
import 'package:recorder/Controllers/States/CollectionsState.dart';
import 'package:provider/provider.dart';
import 'package:recorder/UI/Pages/Collections/StateSelectSeveralCollection.dart';
import 'package:recorder/UI/Pages/Collections/StateAddAudioCollection.dart';
import 'package:recorder/UI/Pages/Collections/StateAddCollection.dart';
import 'package:recorder/UI/Pages/Collections/StateEditCollection.dart';
import 'package:recorder/UI/Pages/Collections/StateLoadingCollection.dart';
import 'package:recorder/UI/Pages/Collections/StateViewCollection.dart';
import 'package:recorder/UI/Pages/Collections/StateViewItemCollection.dart';

class CollectionsPage extends StatefulWidget {
  @override
  _CollectionsPageState createState() => _CollectionsPageState();
}

class _CollectionsPageState extends State<CollectionsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<CollectionsState>(
        stream: context
            .read<GeneralController>()
            .collectionsController
            .streamCollections,
        builder: (context, snapshot) {
          // print("CollectionsPage data " + snapshot.data.toString());
          // print("Collection state => ${snapshot.data.stateSelect}");
          if (!snapshot.hasData) return StateLoadingCollection();
          switch (snapshot.data.stateSelect) {
            case CollectionsSelection.view:
              return StateViewCollection();
              // return StateViewCollection(items: snapshot.data.items);
            case CollectionsSelection.viewItem:
              return StateViewItemCollection();
            case CollectionsSelection.editing:
              return StateEditCollection();
            case CollectionsSelection.add:
              return StateAddCollection();
            case CollectionsSelection.addAudio:
              return StateAddAudioCollection();
            case CollectionsSelection.select:
              return StateSelectSeveralCollection();
            default:
              return StateLoadingCollection();
          }
        },
      ),
    );
  }
}
