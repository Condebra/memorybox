import 'package:flutter/material.dart';
import 'package:recorder/Style.dart';
import 'package:recorder/Utils/Svg/IconSVG.dart';

class SubscriptionPrice {
  final String price;
  final String timeDuration;
  Widget activeIcon = IconSvg(IconsSvg.activeSubscription, height: 50);
  Widget disactiveIcon = IconSvg(IconsSvg.disactiveSubscription, height: 50);

  SubscriptionPrice({
    @required this.price,
    @required this.timeDuration,
  });
}

class ChooseSubscription extends StatefulWidget {
  final List<SubscriptionPrice> items;
  final int currentIndex;
  final Function(int index) onChange;
  ChooseSubscription(
      {@required this.items, this.currentIndex = 0, this.onChange});
  @override
  _ChooseSubscriptionState createState() => _ChooseSubscriptionState();
}

class _ChooseSubscriptionState extends State<ChooseSubscription> {
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(widget.items.length, (index) {
          return GestureDetector(
            onTap: () {
              widget.onChange != null ? widget.onChange(index) : null;
            },
            behavior: HitTestBehavior.deferToChild,
            child: Container(
              width: (MediaQuery.of(context).size.width - 48) / 2,
              height: MediaQuery.of(context).size.height * 240 / 806,
              decoration: BoxDecoration(
                  color: cBackground,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 20,
                        color: cBlack.withOpacity(0.1))
                  ]),
              child: Column(
                children: [
                  SizedBox(
                    height: 69,
                  ),
                  Text(
                    widget.items[index].price,
                    style: TextStyle(
                        fontFamily: fontFamily,
                        color: cBlack,
                        fontSize: 24,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.items[index].timeDuration,
                    style: TextStyle(
                        fontFamily: fontFamily,
                        color: cBlack,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 34,
                  ),
                  index == widget.currentIndex
                      ? widget.items[index].activeIcon
                      : widget.items[index].disactiveIcon ??
                          widget.items[index].activeIcon,
                ],
              ),
            ),
          );
        }));
  }
}
