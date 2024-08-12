import 'package:get_it/get_it.dart';

import '../common/translations/translation_cubit.dart';

class TranslationServiceLocator{
  static void execute({required GetIt serviceLocator}){
    serviceLocator.registerFactory(() => TranslationCubit());
  }
}