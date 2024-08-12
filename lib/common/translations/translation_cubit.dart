import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TranslationCubit extends Cubit<Locale> {
  TranslationCubit() : super(const Locale('en'));

  void changeLanguage(Locale locale, BuildContext context) {
    context.setLocale(locale);
    emit(locale);
  }
}
