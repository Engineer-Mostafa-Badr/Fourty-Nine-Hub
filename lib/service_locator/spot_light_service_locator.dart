// في service_locator.dart

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
