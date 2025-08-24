import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/authentication/presentation/controllers/user_cubit/user_cubit.dart';

extension ContextExtensions on BuildContext {
  // Get the current theme mode
  ThemeMode get themeMode => Theme.of(this).brightness == Brightness.dark
      ? ThemeMode.dark
      : ThemeMode.light;

  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  // Get the current screen height
  double get screenHeight => MediaQuery.of(this).size.height;

  // Get the current screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  // Get the current theme
  ThemeData get theme => Theme.of(this);

  // Get the text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  // Get the current color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  bool get isArabic {
    try {
      return Localizations.localeOf(this).languageCode == 'ar';
    } catch (e) {
      // If context is deactivated, return a default value
      return false;
    }
  }
  TextDirection get textDirection =>
      isArabic ? TextDirection.rtl : TextDirection.ltr;

  FocusScopeNode get foucsScopeNode => FocusScope.of(this);

  bool get isUserLoggedIn => read<UserCubit>().isLoggedIn;
}
