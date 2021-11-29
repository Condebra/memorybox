import 'package:flutter/material.dart';
import 'package:recorder/models/ProfileModel.dart';
import 'package:recorder/Style.dart';
import 'package:recorder/UI/Pages/Profile/widgets/ProgressBar.dart';
import 'package:recorder/generated/l10n.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:recorder/Controllers/GeneralController.dart';

class SubscriptionProgress extends StatefulWidget {
  final ProfileModel person;
  final Function onTap;
  
  SubscriptionProgress({@required this.person, @required this.onTap()});
  
  @override
  _SubscriptionProgressState createState() => _SubscriptionProgressState();
}

class _SubscriptionProgressState extends State<SubscriptionProgress> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          ProgressBar(
            usage:  widget.person.free,
            available: widget.person.max + 7, //+7 because of overflow
            width: MediaQuery.of(context).size.width * 0.74,
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          SizedBox(
            height: 8,
          ),
          Text('Использовано места в облаке: \n${widget.person.max - widget.person.free}/${widget.person.max} мб',
              style: subscriptionTextStyle, textAlign: TextAlign.center,)
        ],
      ),
    );
  }
}
