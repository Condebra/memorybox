import 'package:flutter/material.dart';
import 'package:recorder/Controllers/GeneralController.dart';
import 'package:recorder/Controllers/States/ProfileState.dart';
import 'package:recorder/Utils/app_keys.dart';
import 'package:recorder/models/ProfileModel.dart';
import 'package:recorder/Style.dart';
import 'package:recorder/UI/Pages/Profile/widgets/ProfileImage.dart';
import 'package:recorder/UI/Pages/Profile/widgets/Name.dart';
import 'package:recorder/UI/Pages/Profile/widgets/PhoneNumber.dart';
import 'package:recorder/UI/Pages/Profile/widgets/SubscriptionProgress.dart';
import 'package:recorder/UI/widgets/Appbar.dart';
import 'package:recorder/generated/l10n.dart';
import 'package:recorder/main.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.sync(context.read<GeneralController>().onWillPop),
      child: StreamBuilder<ProfileState>(
          stream:
              context.read<GeneralController>().profileController.streamProfile,
          builder: (context, snapshot) {
            return Scaffold(
              backgroundColor: cBackground.withOpacity(0.0),
              appBar: MyAppBar(
                buttonMore: false,
                buttonBack: snapshot.hasData && snapshot.data.edit,
                buttonMenu: !(snapshot.hasData && snapshot.data.edit),
                padding: 18,
                top: 16,
                height: 90,
                tapLeftButton: () {
                  if (snapshot.hasData && snapshot.data.edit) {
                    context
                        .read<GeneralController>()
                        .profileController
                        .closeEdit();
                  } else {
                    context.read<GeneralController>().setMenu(true);
                  }
                },
                child: Container(
                  child: Column(
                    children: [
                      Text(
                        "Профиль",
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
                        "Твоя частичка",
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
              body: (!snapshot.hasData || snapshot.data.loading)
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      // width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: snapshot.data.edit
                            ? profileIsEdit(snapshot.data)
                            : profileNotEdit(snapshot.data),
                      ),
                    ),
            );
          }),
    );
  }

  Widget profileIsEdit(ProfileState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: ProfileImage(
              isEdit: state.edit,
              person: state.profile,
              imagePath: state.imagePath),
        ),
        ProfileName(isEdit: state.edit, person: state.profile),
        Padding(
          padding: const EdgeInsets.only(top: 60, bottom: 40),
          child: PhoneNumber(isEdit: state.edit, person: state.profile),
        ),
        changeButton(state),
        SizedBox(
          height: 105,
        ),
      ],
    );
  }

  Widget profileNotEdit(ProfileState state) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: ProfileImage(
            isEdit: state.edit,
            person: state.profile,
            imagePath: null,
          ),
        ),
        ProfileName(isEdit: state.edit, person: state.profile),
        PhoneNumber(isEdit: state.edit, person: state.profile),
        changeButton(state),
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: textSubscription(),
        ),
        SubscriptionProgress(person: state.profile),
        Padding(
          padding: const EdgeInsets.only(top: 35, bottom: 120),
          child: bottomButtons(context),
        ),
      ],
    );
  }

  Widget changeButton(ProfileState state) {
    return GestureDetector(
        onTap: () {
          context.read<GeneralController>().createRouteOnEdit(currentPage: 4);
          if (state.edit) {
            context
                .read<GeneralController>()
                .profileController
                .closeAndSaveEdit();
          } else {
            context.read<GeneralController>().profileController.editProfile();
          }
        },
        child: state.edit
            ? Text(S.of(context).save, style: phoneTextStyle(isPhone: false))
            : Text(
                S.of(context).edit_number,
                style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w400, color: cBlack),
              ));
  }

  Container bottomButtons(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.745,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              context
                  .read<GeneralController>()
                  .profileController
                  .logOut(context);
            },
            behavior: HitTestBehavior.deferToChild,
            child: Container(
              child: Text(
                S.of(context).log_out,
                style: bottomProfileTextStyle(isLogOut: true),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              context
                  .read<GeneralController>()
                  .profileController
                  .deleteAccount(context);
            },
            behavior: HitTestBehavior.deferToChild,
            child: Text(
              S.of(context).delete_profile,
              style: bottomProfileTextStyle(isLogOut: false),
            ),
          ),
        ],
      ),
    );
  }

  Widget textSubscription() {
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: () {
        context.read<GeneralController>().openSubscribe();
      },
      child: Container(
        padding: EdgeInsets.only(bottom: 1),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: cBlack, width: 1))),
        child: Text(S.of(context).subscription, style: subscriptionTextStyle),
      ),
    );
  }
}
