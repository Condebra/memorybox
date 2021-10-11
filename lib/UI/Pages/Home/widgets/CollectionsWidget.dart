import 'package:flutter/material.dart';
import 'package:recorder/Controllers/GeneralController.dart';
import 'package:recorder/models/CollectionModel.dart';
import 'package:recorder/UI/Pages/Home/widgets/FirstCollectionItem.dart';
import 'package:recorder/UI/Pages/Home/widgets/SmallCollectionItem.dart';
import 'package:recorder/generated/l10n.dart';
import 'package:provider/provider.dart';

class Collections extends StatefulWidget {
  List<CollectionItem> items;
  Function(CollectionItem) onTapCollection;
  Function onAddCollection;
  bool loading;

  Collections(
      {@required this.items,
      this.onAddCollection,
      this.onTapCollection,
      this.loading});

  @override
  _CollectionsState createState() => _CollectionsState();
}

class _CollectionsState extends State<Collections> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 11), //4 better but
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(S.of(context).collections,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.05,
                    )),
                GestureDetector(
                  behavior: HitTestBehavior.deferToChild,
                  onTap: () {
                    context.read<GeneralController>().setPage(1);
                  },
                  child: Text(S.of(context).open_all,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      )),
                ),
              ],
            ),
          ),
          widget.loading ?? true
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : collectionsPreview()
        ],
      ),
    );
  }

  collectionsPreview() {
    return Container(
      // width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          CollectionItemOne(
            title: widget.items == null || widget.items.length == 0
                ? S.current.titleOfEmptyCollection
                : null,
            onTap: () {
              if (widget.items.length < 1) {
                if (widget.onAddCollection != null) {
                  widget.onAddCollection();
                }
              } else if (widget.onTapCollection != null) {
                widget.onTapCollection(widget.items[0]);
              }
            },
            item: widget.items == null
                ? null
                : widget.items.length > 0
                ? widget.items[0]
                : null,
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            // height: 240,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SmallCollectionItem(
                    item: widget.items == null
                        ? null
                        : widget.items.length > 1
                            ? widget.items[1]
                            : null,
                    audioQuantity:
                        widget.items.length > 1 ? widget.items[1].count : null,
                    img: widget.items.length > 1
                        ? widget.items[1].picture
                        : null,
                    text: widget.items.length == 0
                        ? S.of(context).here
                        : widget.items.length > 1
                            ? null
                            : S.of(context).add,
                    length: widget.items.length,
                    contColor: Color.fromRGBO(241, 180, 136, 0.8),
                    onTap: () {
                      if (widget.items.length < 2) {
                        if (widget.onAddCollection != null) {
                          widget.onAddCollection();
                        }
                      } else if (widget.onTapCollection != null) {
                        widget.onTapCollection(widget.items[1]);
                      }
                    }),
                SizedBox(
                  height: 16,
                ),
                SmallCollectionItem(
                    item: widget.items == null
                        ? null
                        : widget.items.length > 2
                            ? widget.items[2]
                            : null,
                    img: widget.items.length > 2
                        ? widget.items[2].picture
                        : null,
                    audioQuantity:
                        widget.items.length > 2 ? widget.items[2].count : null,
                    text: widget.items.length == 0
                        ? S.of(context).and_here
                        : widget.items.length > 2
                            ? null
                            : S.of(context).add,
                    length: widget.items.length - 1,
                    contColor: Color.fromRGBO(103, 139, 210, 0.8),
                    onTap: () {
                      if (widget.items.length < 3) {
                        if (widget.onAddCollection != null) {
                          widget.onAddCollection();
                        }
                      } else if (widget.onTapCollection != null) {
                        widget.onTapCollection(widget.items[2]);
                      }
                    })
              ],
            ),
          )
        ],
      ),
    );
  }
}
