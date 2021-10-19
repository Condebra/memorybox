import 'package:flutter/material.dart';

class StateLoadingCollection extends StatefulWidget {
  @override
  _StateLoadingCollectionState createState() => _StateLoadingCollectionState();
}

class _StateLoadingCollectionState extends State<StateLoadingCollection> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
