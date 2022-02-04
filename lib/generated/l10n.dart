// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `MemoryBox`
  String get app_name {
    return Intl.message(
      'MemoryBox',
      name: 'app_name',
      desc: '',
      args: [],
    );
  }

  /// `Your voice is always there`
  String get slogan {
    return Intl.message(
      'Your voice is always there',
      name: 'slogan',
      desc: '',
      args: [],
    );
  }

  /// `We are glad to see you`
  String get hello_old {
    return Intl.message(
      'We are glad to see you',
      name: 'hello_old',
      desc: '',
      args: [],
    );
  }

  /// `Hello!`
  String get hello_new1 {
    return Intl.message(
      'Hello!',
      name: 'hello_new1',
      desc: '',
      args: [],
    );
  }

  /// `We are glad to see you there.\nThis app will help you record\nfairy tales and keep them in a convenient place\nnot filling up the memory on the phone`
  String get hello_new2 {
    return Intl.message(
      'We are glad to see you there.\nThis app will help you record\nfairy tales and keep them in a convenient place\nnot filling up the memory on the phone',
      name: 'hello_new2',
      desc: '',
      args: [],
    );
  }

  /// `Adults sometimes need a fairy tale\neven more than children`
  String get hello_old_desc {
    return Intl.message(
      'Adults sometimes need a fairy tale\neven more than children',
      name: 'hello_old_desc',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get btn_next {
    return Intl.message(
      'Continue',
      name: 'btn_next',
      desc: '',
      args: [],
    );
  }

  /// `Hello!`
  String get hello {
    return Intl.message(
      'Hello!',
      name: 'hello',
      desc: '',
      args: [],
    );
  }

  /// `Registering will link your fairy tales\n to the cloud, after which they\n will always be with you`
  String get desc_register {
    return Intl.message(
      'Registering will link your fairy tales\n to the cloud, after which they\n will always be with you',
      name: 'desc_register',
      desc: '',
      args: [],
    );
  }

  /// `Later`
  String get later {
    return Intl.message(
      'Later',
      name: 'later',
      desc: '',
      args: [],
    );
  }

  /// `Enter your phone number`
  String get enter_num {
    return Intl.message(
      'Enter your phone number',
      name: 'enter_num',
      desc: '',
      args: [],
    );
  }

  /// `Enter sms code\nto continue`
  String get enter_code {
    return Intl.message(
      'Enter sms code\nto continue',
      name: 'enter_code',
      desc: '',
      args: [],
    );
  }

  /// `Playlists`
  String get collections {
    return Intl.message(
      'Playlists',
      name: 'collections',
      desc: '',
      args: [],
    );
  }

  /// `Open all`
  String get open_all {
    return Intl.message(
      'Open all',
      name: 'open_all',
      desc: '',
      args: [],
    );
  }

  /// `Audios`
  String get audios {
    return Intl.message(
      'Audios',
      name: 'audios',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Here will be your set of fairy tales`
  String get titleOfEmptyCollection {
    return Intl.message(
      'Here will be your set of fairy tales',
      name: 'titleOfEmptyCollection',
      desc: '',
      args: [],
    );
  }

  /// `Here`
  String get here {
    return Intl.message(
      'Here',
      name: 'here',
      desc: '',
      args: [],
    );
  }

  /// `And here`
  String get and_here {
    return Intl.message(
      'And here',
      name: 'and_here',
      desc: '',
      args: [],
    );
  }

  /// `Once you record the audio, it will appear here.`
  String get text_of_empty_audios {
    return Intl.message(
      'Once you record the audio, it will appear here.',
      name: 'text_of_empty_audios',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Subscription`
  String get subscription {
    return Intl.message(
      'Subscription',
      name: 'subscription',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get log_out {
    return Intl.message(
      'Log out',
      name: 'log_out',
      desc: '',
      args: [],
    );
  }

  /// `Delete account`
  String get delete_profile {
    return Intl.message(
      'Delete account',
      name: 'delete_profile',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Audio`
  String get audio {
    return Intl.message(
      'Audio',
      name: 'audio',
      desc: '',
      args: [],
    );
  }

  /// `Play all`
  String get play_all {
    return Intl.message(
      'Play all',
      name: 'play_all',
      desc: '',
      args: [],
    );
  }

  /// `Audios`
  String get audio_appbar {
    return Intl.message(
      'Audios',
      name: 'audio_appbar',
      desc: '',
      args: [],
    );
  }

  /// `All in one place`
  String get audio_appbar_subtitle {
    return Intl.message(
      'All in one place',
      name: 'audio_appbar_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `More`
  String get more_detailed {
    return Intl.message(
      'More',
      name: 'more_detailed',
      desc: '',
      args: [],
    );
  }

  /// `Expand Your Opportunities`
  String get more_opportunity {
    return Intl.message(
      'Expand Your Opportunities',
      name: 'more_opportunity',
      desc: '',
      args: [],
    );
  }

  /// `Choose plan`
  String get choose_subscription {
    return Intl.message(
      'Choose plan',
      name: 'choose_subscription',
      desc: '',
      args: [],
    );
  }

  /// `299 RUB`
  String get price_for_month {
    return Intl.message(
      '299 RUB',
      name: 'price_for_month',
      desc: '',
      args: [],
    );
  }

  /// `1799 RUB`
  String get price_for_year {
    return Intl.message(
      '1799 RUB',
      name: 'price_for_year',
      desc: '',
      args: [],
    );
  }

  /// `per month`
  String get for_month {
    return Intl.message(
      'per month',
      name: 'for_month',
      desc: '',
      args: [],
    );
  }

  /// `per year`
  String get for_year {
    return Intl.message(
      'per year',
      name: 'for_year',
      desc: '',
      args: [],
    );
  }

  /// `What does subscription offer:`
  String get subscription_preference {
    return Intl.message(
      'What does subscription offer:',
      name: 'subscription_preference',
      desc: '',
      args: [],
    );
  }

  /// `Unlimited cloud space`
  String get no_limit_memory {
    return Intl.message(
      'Unlimited cloud space',
      name: 'no_limit_memory',
      desc: '',
      args: [],
    );
  }

  /// `All files are stored in the cloud`
  String get cloud_storage {
    return Intl.message(
      'All files are stored in the cloud',
      name: 'cloud_storage',
      desc: '',
      args: [],
    );
  }

  /// `Unlimited downloading`
  String get no_limit_downloads {
    return Intl.message(
      'Unlimited downloading',
      name: 'no_limit_downloads',
      desc: '',
      args: [],
    );
  }

  /// `Subscribe monthly`
  String get subscription_for_month {
    return Intl.message(
      'Subscribe monthly',
      name: 'subscription_for_month',
      desc: '',
      args: [],
    );
  }

  /// `Subscribe annual`
  String get subscription_for_year {
    return Intl.message(
      'Subscribe annual',
      name: 'subscription_for_year',
      desc: '',
      args: [],
    );
  }

  /// `Phone number is too short`
  String get short_number {
    return Intl.message(
      'Phone number is too short',
      name: 'short_number',
      desc: '',
      args: [],
    );
  }

  /// `Wrong code`
  String get wrong_code {
    return Intl.message(
      'Wrong code',
      name: 'wrong_code',
      desc: '',
      args: [],
    );
  }

  /// `Code is too short`
  String get short_code {
    return Intl.message(
      'Code is too short',
      name: 'short_code',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message(
      'Share',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `Download`
  String get download {
    return Intl.message(
      'Download',
      name: 'download',
      desc: '',
      args: [],
    );
  }

  /// `Restore`
  String get restore {
    return Intl.message(
      'Restore',
      name: 'restore',
      desc: '',
      args: [],
    );
  }

  /// `No audio`
  String get no_audio {
    return Intl.message(
      'No audio',
      name: 'no_audio',
      desc: '',
      args: [],
    );
  }

  /// `Choose`
  String get choose {
    return Intl.message(
      'Choose',
      name: 'choose',
      desc: '',
      args: [],
    );
  }

  /// `hours`
  String get hours {
    return Intl.message(
      'hours',
      name: 'hours',
      desc: '',
      args: [],
    );
  }

  /// `minutes`
  String get minutes {
    return Intl.message(
      'minutes',
      name: 'minutes',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure?`
  String get sure {
    return Intl.message(
      'Are you sure?',
      name: 'sure',
      desc: '',
      args: [],
    );
  }

  /// `All audio will disappear and it will be impossible to restore the account`
  String get delete_account_body {
    return Intl.message(
      'All audio will disappear and it will be impossible to restore the account',
      name: 'delete_account_body',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `You have audios not uploaded to the cloud. They will disappear on exit`
  String get not_uploaded_audio {
    return Intl.message(
      'You have audios not uploaded to the cloud. They will disappear on exit',
      name: 'not_uploaded_audio',
      desc: '',
      args: [],
    );
  }

  /// `Upload & exit`
  String get upload_exit {
    return Intl.message(
      'Upload & exit',
      name: 'upload_exit',
      desc: '',
      args: [],
    );
  }

  /// `Exit`
  String get exit {
    return Intl.message(
      'Exit',
      name: 'exit',
      desc: '',
      args: [],
    );
  }

  /// `Profile delete succeeded`
  String get delete_account_success {
    return Intl.message(
      'Profile delete succeeded',
      name: 'delete_account_success',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while deleting the profile`
  String get delete_account_error {
    return Intl.message(
      'An error occurred while deleting the profile',
      name: 'delete_account_error',
      desc: '',
      args: [],
    );
  }

  /// `Select several`
  String get select_several {
    return Intl.message(
      'Select several',
      name: 'select_several',
      desc: '',
      args: [],
    );
  }

  /// `Delete playlist`
  String get delete_playlist {
    return Intl.message(
      'Delete playlist',
      name: 'delete_playlist',
      desc: '',
      args: [],
    );
  }

  /// `Playlist`
  String get playlist {
    return Intl.message(
      'Playlist',
      name: 'playlist',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Record`
  String get record {
    return Intl.message(
      'Record',
      name: 'record',
      desc: '',
      args: [],
    );
  }

  /// `Record will be permanently deleted`
  String get delete_record {
    return Intl.message(
      'Record will be permanently deleted',
      name: 'delete_record',
      desc: '',
      args: [],
    );
  }

  /// `Enter a name`
  String get enter_name {
    return Intl.message(
      'Enter a name',
      name: 'enter_name',
      desc: '',
      args: [],
    );
  }

  /// `Enter description`
  String get enter_description {
    return Intl.message(
      'Enter description',
      name: 'enter_description',
      desc: '',
      args: [],
    );
  }

  /// `It's empty`
  String get empty {
    return Intl.message(
      'It`s empty',
      name: 'empty',
      desc: '',
      args: [],
    );
  }

  /// `Anonymous`
  String get anonymous {
    return Intl.message(
      'Anonymous',
      name: 'anonymous',
      desc: '',
      args: [],
    );
  }

  /// `John Smith`
  String get fake_name {
    return Intl.message(
      'John Smith',
      name: 'fake_name',
      desc: '',
      args: [],
    );
  }

  /// `Used cloud space`
  String get used_cloud_space {
    return Intl.message(
      'Used cloud space',
      name: 'used_cloud_space',
      desc: '',
      args: [],
    );
  }

  /// `MB`
  String get mb {
    return Intl.message(
      'MB',
      name: 'mb',
      desc: '',
      args: [],
    );
  }

  /// `all`
  String get all {
    return Intl.message(
      'all',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `Recently deleted`
  String get recently_deleted {
    return Intl.message(
      'Recently deleted',
      name: 'recently_deleted',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Your particle`
  String get your_particle {
    return Intl.message(
      'Your particle',
      name: 'your_particle',
      desc: '',
      args: [],
    );
  }

  /// `You have unlimited cloud space.`
  String get you_unlimited {
    return Intl.message(
      'You have unlimited cloud space.',
      name: 'you_unlimited',
      desc: '',
      args: [],
    );
  }

  /// `Thanks for your support!`
  String get premium_thanks {
    return Intl.message(
      'Thanks for your support!',
      name: 'premium_thanks',
      desc: '',
      args: [],
    );
  }

  /// `You already have a subscription.`
  String get already_have_premium {
    return Intl.message(
      'You already have a subscription.',
      name: 'already_have_premium',
      desc: '',
      args: [],
    );
  }

  /// `Login to the app to use all its features!`
  String get login_perks {
    return Intl.message(
      'Login to the app to use all its features!',
      name: 'login_perks',
      desc: '',
      args: [],
    );
  }

  /// `Login to the application`
  String get login {
    return Intl.message(
      'Login to the application',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Playlists`
  String get playlists {
    return Intl.message(
      'Playlists',
      name: 'playlists',
      desc: '',
      args: [],
    );
  }

  /// `All in one place`
  String get all_in_one_place {
    return Intl.message(
      'All in one place',
      name: 'all_in_one_place',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Find the lost`
  String get find_lost {
    return Intl.message(
      'Find the lost',
      name: 'find_lost',
      desc: '',
      args: [],
    );
  }

  /// `Main`
  String get main {
    return Intl.message(
      'Main',
      name: 'main',
      desc: '',
      args: [],
    );
  }

  /// `Add to playlist`
  String get add_to_playlist {
    return Intl.message(
      'Add to playlist',
      name: 'add_to_playlist',
      desc: '',
      args: [],
    );
  }

  /// `Upload to cloud`
  String get upload_to_cloud {
    return Intl.message(
      'Upload to cloud',
      name: 'upload_to_cloud',
      desc: '',
      args: [],
    );
  }

  /// `Listen to my fairy tale`
  String get share_msg {
    return Intl.message(
      'Listen to my fairy tale',
      name: 'share_msg',
      desc: '',
      args: [],
    );
  }

  /// `Delete from phone`
  String get delete_local {
    return Intl.message(
      'Delete from phone',
      name: 'delete_local',
      desc: '',
      args: [],
    );
  }

  /// `Delete from cloud`
  String get delete_cloud {
    return Intl.message(
      'Delete from cloud',
      name: 'delete_cloud',
      desc: '',
      args: [],
    );
  }

  /// `Record will be removed to trash\n so you can restore it`
  String get delete_to_trash {
    return Intl.message(
      'Record will be removed to trash\n so you can restore it',
      name: 'delete_to_trash',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Length`
  String get length {
    return Intl.message(
      'Length',
      name: 'length',
      desc: '',
      args: [],
    );
  }

  /// `Created at`
  String get created_at {
    return Intl.message(
      'Created at',
      name: 'created_at',
      desc: '',
      args: [],
    );
  }

  /// `Uploaded to the cloud`
  String get uploaded {
    return Intl.message(
      'Uploaded to the cloud',
      name: 'uploaded',
      desc: '',
      args: [],
    );
  }

  /// `Support`
  String get support {
    return Intl.message(
      'Support',
      name: 'support',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}