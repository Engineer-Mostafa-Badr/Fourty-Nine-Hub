// في service_locator.dart
import 'package:dio/dio.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/features/social_media/spot_light/data/data_source/spotlight_data_source.dart';
import 'package:fourtyninehub/features/social_media/spot_light/data/repos/spotlight_repo_impl.dart';
import 'package:fourtyninehub/features/social_media/spot_light/domain/repos/spotlight_repo.dart';
import 'package:fourtyninehub/features/social_media/spot_light/presentation/logic/spot_light_cubit.dart';
import 'package:get_it/get_it.dart';

// class SpotlightServiceLocator {
//   static Future<void> execute({required GetIt serviceLocator}) async {
//     // Register Spotlight Data Source
//     serviceLocator.registerLazySingleton<SpotlightDataSource>(
//       () => SpotlightDataSourceImpl(
//         api: serviceLocator<ApiConsumer>(),
//         uploadDio: serviceLocator<Dio>(instanceName: 'uploadDio'),
//       ),
//     );
//
//     // Register Spotlight Repository
//     serviceLocator.registerLazySingleton<SpotlightRepository>(
//       () => SpotlightRepositoryImpl(
//         dataSource: serviceLocator<SpotlightDataSource>(),
//       ),
//     );
//
//     // Register Spotlight Cubit
//     serviceLocator.registerFactory<SpotlightCubit>(
//       () => SpotlightCubit(
//         repository: serviceLocator<SpotlightRepository>(),
//       ),
//     );
//   }
// }
