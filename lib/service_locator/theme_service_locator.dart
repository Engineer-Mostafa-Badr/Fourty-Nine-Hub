import 'package:get_it/get_it.dart';

import '../common/theme/cubit/cubit.dart';
import '../common/translations/translation_cubit.dart';

class ThemeServiceLocator{

  static void execute({required GetIt serviceLocator}){
    serviceLocator.registerFactory(() => ThemeCubit());
  }
}