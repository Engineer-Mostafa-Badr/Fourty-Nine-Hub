import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/theme/cubit/states.dart';


class ThemeCubit extends Cubit<ThemeStates>
{
  ThemeCubit():super(ThemeInitialStates());
  static ThemeCubit get(context)=>BlocProvider.of(context);


   bool isDarkTheme =true;

  void changeThemeMode() {
    isDarkTheme = !isDarkTheme;
    //await SharedPreference.saveData(key: 'Theme', value: isDarkTheme);
    emit(ChangeThemeModeStates());
    print(isDarkTheme);
  }

}