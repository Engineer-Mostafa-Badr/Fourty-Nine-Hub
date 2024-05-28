import 'package:fourtyninehub/features/fourty_nine/data/data_sources/remote_data_source/fourty_nine_remote_data_source.dart';
import 'package:fourtyninehub/features/fourty_nine/data/repositories/fourty_nine_repository_impl.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/repositories/fourty_nine_repository.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/use_cases/get_main_categories_use_case.dart';
import 'package:get_it/get_it.dart';

import '../features/fourty_nine/domain/use_cases/get_parent_main_categories_use_case.dart';
import '../features/fourty_nine/presentation/controllers/main_categories_cubit/parent_main_categories_cubit.dart';
import '../features/fourty_nine/presentation/controllers/parent_main_categories_cubit/main_categories_cubit.dart';

class FourtyNineServiceLocator {
  static void execute(GetIt serviceLocator) {
    serviceLocator.registerLazySingleton<FourtyNineRemoteDataSource>(
      () => FourtyNineRemoteDataSourceImpl(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<FourtyNineRepository>(
      () => FourtyNineRepositoryImpl(
        serviceLocator(),
      ),
    );

    // use cases
    serviceLocator.registerLazySingleton<GetParentMainCategoriesUseCase>(
      () => GetParentMainCategoriesUseCase(
        serviceLocator(),
      ),
    );
    serviceLocator.registerLazySingleton<GetMainCategoriesUseCase>(
      () => GetMainCategoriesUseCase(
        serviceLocator(),
      ),
    );

    // cubits
    serviceLocator.registerSingleton(
      ParentMainCategoriesCubit(
        serviceLocator(),
      )..getParentMainCategories(),
    );
    serviceLocator.registerSingleton(
      MainCategoriesCubit(
        serviceLocator(),
      )..getMainCategories(),
    );
  }
}
