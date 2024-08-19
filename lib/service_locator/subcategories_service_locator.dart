import 'package:fourtyninehub/features/subcategories/data/datasources/subcategories_remote_datasource.dart';
import 'package:fourtyninehub/features/subcategories/data/repositories/subcategories_repo_impl.dart';
import 'package:fourtyninehub/features/subcategories/domain/repositories/subcategories_repo.dart';
import 'package:fourtyninehub/features/subcategories/domain/usecases/get_sub_categories_use_case.dart';
import 'package:fourtyninehub/features/subcategories/presentation/cubit/subcategories_cubit.dart';
import 'package:get_it/get_it.dart';

class SubcategoriesServiceLocator {
  static void execute({required GetIt serviceLocator}) async {
    // -------------------Data Source ----------------------
    serviceLocator.registerLazySingleton<SubcategoriesRemoteDataSource>(
        () => SubcategoriesRemoteDataSourceImpl(serviceLocator()));
    // --------------------Repository ----------------------
    serviceLocator.registerLazySingleton<SubcategoriesRepo>(
        () => SubcategoriesRepoImpl(serviceLocator()));
    // -------------------Usecase -------------------------
    serviceLocator.registerLazySingleton<GetSubCategoriesUseCase>(
        () => GetSubCategoriesUseCase(serviceLocator()));
    // --------------------Cubit ---------------------------
    serviceLocator.registerFactory<SubcategoriesCubit>(
        () => SubcategoriesCubit(serviceLocator()));
  }
}
