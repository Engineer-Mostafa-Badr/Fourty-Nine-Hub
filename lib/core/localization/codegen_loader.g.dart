// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes, avoid_renaming_method_parameters

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> ar = {
  "join": "انضم الآن",
  "arabic": "اللغه العربيه",
  "english": "اللغه الانجليزيه",
  "newMeeting": "اجتماع جديد",
  "meal": "اكله",
  "darkMode": "الوضع الداكن",
  "lightMode": "الوضع الفاتح",
  "voice": "صوت",
  "meet": "زوم",
  "cast": "سرعة",
  "tweet": "تويته",
  "reels": "بكرات",
  "chat": "شات",
  "find": "ايجاد",
  "live": "لابف",
  "health": "صحه",
  "shipping": "تحميله",
  "ride": "توصيله",
  "lang": "EN",
  "search": "بحث"
};
static const Map<String,dynamic> en = {
  "join": "Join",
  "arabic": "Arabic",
  "english": "English",
  "newMeeting": "New Meeting",
  "meal": "Meal",
  "darkMode": "Dark mode",
  "lightMode": "Light mode",
  "voice": "Voice",
  "meet": "Meet",
  "cast": "Cast",
  "tweet": "Tweet",
  "reels": "Reels",
  "chat": "Chat",
  "find": "Find",
  "live": "Live",
  "health": "Health",
  "shipping": "Shipping",
  "ride": "Ride",
  "lang": "ع",
  "search": "Search"
};
static const Map<String, Map<String,dynamic>> mapLocales = {"ar": ar, "en": en};
}
