import 'package:fourtyninehub/features/food_feature/edit_food/presentation/cubit/edit_food_cubit.dart';
import 'package:get_it/get_it.dart';

class EditFoodServiceLocator {
  static void execute({required GetIt serviceLocator}) async {
    // -------------------Data Source ----------------------

    // -------------------Repository ----------------------

    // -------------------UseCases ----------------------

    serviceLocator.registerFactory<EditFoodCubit>(() => EditFoodCubit(
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
        ));
  }
}
