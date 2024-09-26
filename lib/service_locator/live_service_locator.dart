import 'package:fourtyninehub/features/social_media/live_streaming/domain/usecases/get_all_lives_use_case.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/usecases/get_all_topics_use_case.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/usecases/create_live_use_case.dart';
import 'package:get_it/get_it.dart';

import '../features/social_media/live_streaming/data/datasource/live_datasource.dart';
import '../features/social_media/live_streaming/data/repository/live_repository_impl.dart';
import '../features/social_media/live_streaming/domain/repository/live_repository.dart';

class LiveServiceLocator {
  static Future<void> execute({required GetIt serviceLocator}) async {
    //concrete class return implementation class
    serviceLocator.registerLazySingleton<LiveDataSource>(
      () => LiveDataSourceImpl(
        apiConsumer: serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<LiveRepository>(
      () => LiveRepositoryImpl(
        liveDataSource: serviceLocator(),
      ),
    );
    //usecases
    serviceLocator.registerFactory(
        () => GetAllTopicsUseCase(liveRepository: serviceLocator()));
    serviceLocator.registerFactory(() => CreateLiveUseCase(serviceLocator()));
    serviceLocator.registerFactory(
        () => GetAllLivesUseCase(liveRepository: serviceLocator()));

    //cubit is extension method on stream cubit
  }
}
