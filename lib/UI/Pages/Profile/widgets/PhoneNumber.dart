import 'package:flutter/material.dart';
import 'package:recorder/Controllers/GeneralController.dart';
import 'package:recorder/models/ProfileModel.dart';
import 'package:recorder/Style.dart';
import 'package:recorder/generated/l10n.dart';
import 'package:provider/provider.dart';
class PhoneNumber extends StatefulWidget {
  bool isEdit;
  ProfileModel person;
  PhoneNumber({@required this.isEdit, @required this.person});
  @override
  _PhoneNumberState createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
  @override
  Widget build(BuildContext context) {
    return widget.isEdit ? phoneIsEdit(context) : phoneNotEdit(context);
  }

  Widget phoneNotEdit(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.77,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(41),
                color: cBackground,
                border: Border.all(color: cBlack.withOpacity(0.2), width: 1),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 4),
                      blurRadius: 11,
                      color: Color.fromRGBO(0, 0, 0, 0.17))
                ]),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  '${widget.person.phone??"Нет номера"}',
                  style: phoneTextStyle(isPhone: true),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget phoneIsEdit(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.77,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(41),
              color: cBackground,
              border: Border.all(color: cBlack.withOpacity(0.2), width: 1),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 4),
                    blurRadius: 11,
                    color: Color.fromRGBO(0, 0, 0, 0.17))
              ]),
          child: Center(
            child: Padding(
              // ????????????? why 10 px not 20?????????????????
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: TextField(
                controller: context.read<GeneralController>().profileController.controllerNum,
                inputFormatters: [
                  context.read<GeneralController>().profileController.maskFormatter
                ],
                textAlign: TextAlign.center,
                cursorColor: Color.fromRGBO(64, 64, 64, 1),
                style: phoneTextStyle(isPhone: true),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: widget.person.phone,
                  hintStyle: phoneTextStyle(isPhone: true),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
