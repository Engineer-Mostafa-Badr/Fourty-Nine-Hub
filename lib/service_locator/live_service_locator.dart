import 'package:fourtyninehub/features/social_media/live_streaming/domain/usecases/get_all_lives_use_case.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/usecases/get_all_topics_use_case.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/usecases/create_live_use_case.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/usecases/listen_batttle_request_use_case.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/usecases/listen_to_send_points_use_case.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/usecases/request_battle_use_case.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/domain/usecases/send_points_use_case.dart';
import 'package:get_it/get_it.dart';

import '../features/social_media/live_streaming/data/datasource/live_datasource.dart';
import '../features/social_media/live_streaming/data/repository/live_repository_impl.dart';
import '../features/social_media/live_streaming/domain/repository/live_repository.dart';
import '../features/social_media/live_streaming/domain/usecases/end_live_use_case.dart';

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
    serviceLocator.registerFactory(() => EndLiveUseCase(serviceLocator()));
    serviceLocator.registerFactory(() => SendPointsUseCase(serviceLocator()));
    serviceLocator
        .registerFactory(() => RequestBattleUseCase(serviceLocator()));
    serviceLocator
        .registerFactory(() => ListenBattleRequestUseCase(serviceLocator()));
    serviceLocator
        .registerFactory(() => ListenToSendPointsUseCase(serviceLocator()));
    serviceLocator.registerFactory(
        () => GetAllLivesUseCase(liveRepository: serviceLocator()));

    //cubit is extension method on stream cubit
  }
}
