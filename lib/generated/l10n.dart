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

  /// `Твой голос всегда рядом`
  String get slogan {
    return Intl.message(
      'Твой голос всегда рядом',
      name: 'slogan',
      desc: '',
      args: [],
    );
  }

  /// `Мы рады тебя видеть`
  String get hello_old {
    return Intl.message(
      'Мы рады тебя видеть',
      name: 'hello_old',
      desc: '',
      args: [],
    );
  }

  /// `Привет!`
  String get hello_new1 {
    return Intl.message(
      'Привет!',
      name: 'hello_new1',
      desc: '',
      args: [],
    );
  }

  /// `Мы рады видеть тебя здесь.\nЭто приложение поможет записывать \nсказки и держать их в удобном месте\n не заполняя память на телефоне`
  String get hello_new2 {
    return Intl.message(
      'Мы рады видеть тебя здесь.\nЭто приложение поможет записывать \nсказки и держать их в удобном месте\n не заполняя память на телефоне',
      name: 'hello_new2',
      desc: '',
      args: [],
    );
  }

  /// `Взрослые иногда нуждаются \nв сказке даже больше, чем дети`
  String get hello_old_desc {
    return Intl.message(
      'Взрослые иногда нуждаются \nв сказке даже больше, чем дети',
      name: 'hello_old_desc',
      desc: '',
      args: [],
    );
  }

  /// `Продолжить`
  String get btn_next {
    return Intl.message(
      'Продолжить',
      name: 'btn_next',
      desc: '',
      args: [],
    );
  }

  /// `Привет!`
  String get hello {
    return Intl.message(
      'Привет!',
      name: 'hello',
      desc: '',
      args: [],
    );
  }

  /// `Регистрация привяжет твои сказки \n к облаку, после чего они всегда\n будут с тобой`
  String get desc_register {
    return Intl.message(
      'Регистрация привяжет твои сказки \n к облаку, после чего они всегда\n будут с тобой',
      name: 'desc_register',
      desc: '',
      args: [],
    );
  }

  /// `Позже`
  String get later {
    return Intl.message(
      'Позже',
      name: 'later',
      desc: '',
      args: [],
    );
  }

  /// `Введите номер телефона`
  String get enter_num {
    return Intl.message(
      'Введите номер телефона',
      name: 'enter_num',
      desc: '',
      args: [],
    );
  }

  /// `Введи код из смс, чтобы \nмы тебя запомнили`
  String get enter_code {
    return Intl.message(
      'Введи код из смс, чтобы \nмы тебя запомнили',
      name: 'enter_code',
      desc: '',
      args: [],
    );
  }

  /// `Подборки`
  String get collections {
    return Intl.message(
      'Подборки',
      name: 'collections',
      desc: '',
      args: [],
    );
  }

  /// `Открыть все`
  String get open_all {
    return Intl.message(
      'Открыть все',
      name: 'open_all',
      desc: '',
      args: [],
    );
  }

  /// `Аудиозаписи`
  String get audios {
    return Intl.message(
      'Аудиозаписи',
      name: 'audios',
      desc: '',
      args: [],
    );
  }

  /// `Добавить`
  String get add {
    return Intl.message(
      'Добавить',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Здесь будет твой набор сказок`
  String get titleOfEmptyCollection {
    return Intl.message(
      'Здесь будет твой набор сказок',
      name: 'titleOfEmptyCollection',
      desc: '',
      args: [],
    );
  }

  /// `Тут`
  String get here {
    return Intl.message(
      'Тут',
      name: 'here',
      desc: '',
      args: [],
    );
  }

  /// `И тут`
  String get and_here {
    return Intl.message(
      'И тут',
      name: 'and_here',
      desc: '',
      args: [],
    );
  }

  /// `Как только ты запишешь аудио, она появится здесь.`
  String get text_of_empty_audios {
    return Intl.message(
      'Как только ты запишешь аудио, она появится здесь.',
      name: 'text_of_empty_audios',
      desc: '',
      args: [],
    );
  }

  /// `Редактировать`
  String get edit_number {
    return Intl.message(
      'Редактировать',
      name: 'edit_number',
      desc: '',
      args: [],
    );
  }

  /// `Подписка`
  String get subscription {
    return Intl.message(
      'Подписка',
      name: 'subscription',
      desc: '',
      args: [],
    );
  }

  /// `Выйти из приложения`
  String get log_out {
    return Intl.message(
      'Выйти из приложения',
      name: 'log_out',
      desc: '',
      args: [],
    );
  }

  /// `Удалить аккаунт`
  String get delete_profile {
    return Intl.message(
      'Удалить аккаунт',
      name: 'delete_profile',
      desc: '',
      args: [],
    );
  }

  /// `Сохранить`
  String get save {
    return Intl.message(
      'Сохранить',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `аудио`
  String get audio {
    return Intl.message(
      'аудио',
      name: 'audio',
      desc: '',
      args: [],
    );
  }

  /// `Запустить все`
  String get play_all {
    return Intl.message(
      'Запустить все',
      name: 'play_all',
      desc: '',
      args: [],
    );
  }

  /// `Аудиозаписи`
  String get audio_appbar {
    return Intl.message(
      'Аудиозаписи',
      name: 'audio_appbar',
      desc: '',
      args: [],
    );
  }

  /// `Все в одном месте`
  String get audio_appbar_subtitle {
    return Intl.message(
      'Все в одном месте',
      name: 'audio_appbar_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Подробнее`
  String get more_detailed {
    return Intl.message(
      'Подробнее',
      name: 'more_detailed',
      desc: '',
      args: [],
    );
  }

  /// `Расширь возможности`
  String get more_opportunity {
    return Intl.message(
      'Расширь возможности',
      name: 'more_opportunity',
      desc: '',
      args: [],
    );
  }

  /// `Выбери подписку`
  String get choose_subscription {
    return Intl.message(
      'Выбери подписку',
      name: 'choose_subscription',
      desc: '',
      args: [],
    );
  }

  /// `300р`
  String get price_for_month {
    return Intl.message(
      '300р',
      name: 'price_for_month',
      desc: '',
      args: [],
    );
  }

  /// `1800р`
  String get price_for_year {
    return Intl.message(
      '1800р',
      name: 'price_for_year',
      desc: '',
      args: [],
    );
  }

  /// `в месяц`
  String get for_month {
    return Intl.message(
      'в месяц',
      name: 'for_month',
      desc: '',
      args: [],
    );
  }

  /// `в год`
  String get for_year {
    return Intl.message(
      'в год',
      name: 'for_year',
      desc: '',
      args: [],
    );
  }

  /// `Что дает подписка:`
  String get subscription_preference {
    return Intl.message(
      'Что дает подписка:',
      name: 'subscription_preference',
      desc: '',
      args: [],
    );
  }

  /// `Неограниченая память`
  String get no_limit_memory {
    return Intl.message(
      'Неограниченая память',
      name: 'no_limit_memory',
      desc: '',
      args: [],
    );
  }

  /// `Все файлы хранятся в облаке`
  String get cloud_storage {
    return Intl.message(
      'Все файлы хранятся в облаке',
      name: 'cloud_storage',
      desc: '',
      args: [],
    );
  }

  /// `Возможность скачивать без ограничений`
  String get no_limit_downloads {
    return Intl.message(
      'Возможность скачивать без ограничений',
      name: 'no_limit_downloads',
      desc: '',
      args: [],
    );
  }

  /// `Подписаться на месяц`
  String get subscription_for_month {
    return Intl.message(
      'Подписаться на месяц',
      name: 'subscription_for_month',
      desc: '',
      args: [],
    );
  }

  /// `Подписаться на год`
  String get subscription_for_year {
    return Intl.message(
      'Подписаться на год',
      name: 'subscription_for_year',
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