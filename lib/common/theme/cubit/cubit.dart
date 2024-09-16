import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/theme/cubit/states.dart';

import '../../../core/utils/theme_service.dart';

class ThemeCubit extends Cubit<ThemeStates> {
  ThemeCubit() : super(LightThemeModeStates());
  static ThemeCubit get(context) => BlocProvider.of(context);

  bool isDarkTheme = false;

  Future<void> lightThemeMode() async {
    isDarkTheme = false;
    await ThemeServices.savethemeMode(false);
    emit(LightThemeModeStates());
    print(isDarkTheme);
    print('isDark saved to ${ThemeServices.getThemeMode()}');
  }

  Future<void> darkThemeMode() async {
    isDarkTheme = true;
    await ThemeServices.savethemeMode(true);
    emit(DarkThemeModeStates());
    print(isDarkTheme);
    print('isDark saved to ${ThemeServices.getThemeMode()}');
  }
}
