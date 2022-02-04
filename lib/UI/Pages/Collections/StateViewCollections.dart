import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recorder/Controllers/GeneralController.dart';
import 'package:recorder/Controllers/States/CollectionsState.dart';
import 'package:recorder/Style.dart';
import 'package:recorder/UI/Pages/Home/widgets/CollectionItemOne.dart';
import 'package:recorder/UI/widgets/Appbar.dart';
import 'package:provider/provider.dart';
import 'package:recorder/generated/l10n.dart';

class StateViewCollection extends StatefulWidget {

  StateViewCollection();

  @override
  _StateViewCollectionState createState() => _StateViewCollectionState();
}

class _StateViewCollectionState extends State<StateViewCollection> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBlack.withOpacity(0.0),
      appBar: MyAppBar(
        buttonMore: false,
        buttonMenu: false,
        buttonBack: false,
        buttonAdd: true,
        padding: 10,
        top: 25,
        height: 90,
        tapLeftButton: () {
          context
              .read<GeneralController>()
              .collectionsController
              .addCollection();
          context
              .read<GeneralController>()
              .createRouteOnEdit(currentPage: 1);
        },
        child: Container(
          child: Column(
            children: [
              Text(
                S.current.playlists,
                style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    fontFamily: fontFamilyMedium,
                    letterSpacing: 2),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                S.current.all_in_one_place,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: fontFamilyMedium,
                    letterSpacing: 2),
              )
            ],
          ),
        ),
      ),
      body: StreamBuilder<CollectionsState> (
        stream: context
          .read<GeneralController>()
          .collectionsController
          .streamCollections,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator(),);
          if (snapshot.data.items == null || snapshot.data.items.isEmpty)
            return Center(
              child: Text(
                S.current.empty,
                style: TextStyle(
                    color: cBlack.withOpacity(0.7),
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    fontFamily: fontFamily),
              ),
            );
          return GridView.count(
            crossAxisCount: 2,
            padding: EdgeInsets.fromLTRB(16, 50, 16, 116),
            crossAxisSpacing: 10,
            mainAxisSpacing: 16,
            physics: BouncingScrollPhysics(),
            children: List.generate(
              snapshot.data.items.length,
              (index) => Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.01),
                      offset: Offset(4, 4),
                      blurRadius: 10,
                      spreadRadius: 3,
                    )
                  ],
                ),
                child: CollectionItemOne(
                  onTap: () {
                    context
                        .read<GeneralController>()
                        .collectionsController
                        .view(snapshot.data.items[index]);
                    context
                        .read<GeneralController>()
                        .createRouteOnEdit(currentPage: 1);
                  },
                  item: snapshot.data.items[index],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
