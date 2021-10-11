import 'package:flutter/material.dart';
import 'package:recorder/Controllers/GeneralController.dart';
import 'package:recorder/Controllers/States/ProfileState.dart';
import 'package:recorder/Utils/app_keys.dart';
import 'package:recorder/models/ProfileModel.dart';
import 'package:recorder/Style.dart';
import 'package:recorder/UI/Pages/Profile/widgets/Image.dart';
import 'package:recorder/UI/Pages/Profile/widgets/Name.dart';
import 'package:recorder/UI/Pages/Profile/widgets/PhoneNumber.dart';
import 'package:recorder/UI/Pages/Profile/widgets/SubscribtionProgress.dart';
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
    return Navigator(
      key: AppKeys.navigatorKey,
      onGenerateRoute: (route)=> MaterialPageRoute(settings: route, builder: (context)=>SafeArea(
        child: StreamBuilder<ProfileState>(
            stream: context.read<GeneralController>().profileController.streamProfile,
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
                tapLeftButton: (){
                  if(snapshot.hasData && snapshot.data.edit){
                    context.read<GeneralController>().profileController.closeEdit();
                  }else{
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
              body: (!snapshot.hasData || snapshot.data.loading)?Center(child: CircularProgressIndicator(),):SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      height: 66,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: snapshot.data.edit ? profileIsEdit(snapshot.data) : profileNotEdit(snapshot.data),
                    ),
                  ],
                ),
              ),
            );
          }
        ),
      )),
    );
  }

  Widget profileIsEdit(ProfileState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ProfileImage(isEdit: state.edit, person: state.profile, imagePath: state.imagePath),
        SizedBox(
          height: 40,
        ),
        ProfileName(isEdit: state.edit, person:state.profile),
        SizedBox(
          height: 80,
        ),
        PhoneNumber(isEdit: state.edit, person: state.profile),
        SizedBox(
          height: 40,
        ),
        changeButton(state),
        SizedBox(height: 105,),
      ],
    );
  }

  Widget profileNotEdit(ProfileState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ProfileImage(isEdit: state.edit, person:state.profile, imagePath: null,),
        SizedBox(
          height: 14,
        ),
        ProfileName(isEdit: state.edit, person: state.profile),
        PhoneNumber(isEdit: state.edit, person: state.profile),
        changeButton(state),
        SizedBox(
          height: 45,
        ),
        textSubscription(),
        SubcriptionProgress(person:state.profile),
        SizedBox(
          height: 65,
        ),
        bottomButtons(context),
        SizedBox(
          height: 140,
        ),
      ],
    );
  }

  Widget changeButton(ProfileState state) {
    return GestureDetector(
        onTap: () {
          if(state.edit){
            context.read<GeneralController>().profileController.closeAndSaveEdit();

          }else{
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
              context.read<GeneralController>().profileController.comeOut();
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
              context.read<GeneralController>().profileController.deleteAccount();
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
      onTap: (){
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
