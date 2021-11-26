import 'package:flutter/material.dart';
import 'package:recorder/models/ProfileModel.dart';

class ProfileState{
  final bool loading;
  final bool edit;
  final ProfileModel profile;
  final String imagePath;

  const ProfileState({
    @required this.loading,
    @required this.edit,
    @required this.profile,
    @required this.imagePath
  });
}