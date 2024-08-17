import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/theme/cubit/states.dart';


class ThemeCubit extends Cubit<ThemeStates>
{
  ThemeCubit():super(LightThemeModeStates());
  static ThemeCubit get(context)=>BlocProvider.of(context);


   bool isDarkTheme =false;

  void lightThemeMode() {
    isDarkTheme = false;
    emit(LightThemeModeStates());
    print(isDarkTheme);
  }

  void darkThemeMode() {
    isDarkTheme = true;
    emit(DarkThemeModeStates());
    print(isDarkTheme);
  }

}