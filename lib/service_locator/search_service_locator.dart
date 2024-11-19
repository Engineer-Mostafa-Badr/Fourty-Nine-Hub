import 'package:fourtyninehub/features/search/data/data_source/search_remote_data_source.dart';
import 'package:fourtyninehub/features/search/data/repository/search_repository_impl.dart';
import 'package:fourtyninehub/features/search/domain/repository/search_repository.dart';
import 'package:fourtyninehub/features/search/domain/use_case/fetch_search_use_case.dart';
import 'package:fourtyninehub/features/search/domain/use_case/fetch_user_search_use_case.dart';
import 'package:fourtyninehub/features/search/presentation/controller/cubit/search_cubit.dart';
import 'package:get_it/get_it.dart';

class SearchServiceLocator {
  static Future<void> execute({required GetIt serviceLocator}) async {
    serviceLocator.registerLazySingleton<SearchRemoteDataSource>(
        () => SearchRemoteDataSourceImpl(
              serviceLocator(),
            ));

    serviceLocator
        .registerLazySingleton<SearchRepository>(() => SearchRepositoryImpl(
              serviceLocator(),
            ));

    serviceLocator
        .registerLazySingleton<FetchSearchUseCase>(() => FetchSearchUseCase(
              serviceLocator(),
            ));
    serviceLocator.registerLazySingleton<FetchUserSearchUseCase>(
        () => FetchUserSearchUseCase(
              serviceLocator(),
            ));

    serviceLocator.registerFactory<SearchCubit>(() => SearchCubit(
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
        ));
  }
}
