import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/theme/cubit/states.dart';
import 'package:fourtyninehub/core/utils/shared_pref.dart';


class ThemeCubit extends Cubit<ThemeStates> {
  ThemeCubit() : super(LightThemeModeStates());

  static ThemeCubit get(context) => BlocProvider.of(context);

  bool isDarkTheme = false;

  Future<void> lightThemeMode() async {
    isDarkTheme = false;
    await CacheManager.isDarkMode(isDarkTheme);
    emit(LightThemeModeStates());
    print(isDarkTheme);
    print('isDark saved to ${await CacheManager.getMode()}');
  }

  Future<void> darkThemeMode() async {
    isDarkTheme = true;
    await CacheManager.isDarkMode(isDarkTheme);
    emit(DarkThemeModeStates());
    print(isDarkTheme);
    print('isDark saved to ${await CacheManager.getMode()}');

  }
}
