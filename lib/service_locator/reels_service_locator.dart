// import 'package:fourtyninehub/features/social_media/reels/data/repositories/reels_repository_impl.dart';
// import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/explore_reels_cubit/explore_reels_cubit.dart';
// import 'package:get_it/get_it.dart';
//
// class ReelsServiceLocator {
//   static void execute(GetIt serviceLocator) {
//     // serviceLocator.registerLazySingleton<ReelsRemoteDataSource>(
//     //   () => ReelsRemoteDataSourceImpl(
//     //     serviceLocator(),
//     //   ),
//     // );
//     //
//     serviceLocator.registerLazySingleton<ReelsRepository>(
//       () => ReelsRepository(),
//     );
//     //
//     // // use cases
//     // serviceLocator.registerLazySingleton<GetExploreReelsUseCase>(
//     //   () => GetExploreReelsUseCase(
//     //     serviceLocator(),
//     //   ),
//     // );
//
//     // cubits
//     serviceLocator.registerFactory<ReelsCubit>(
//       () => ReelsCubit(
//         repository: serviceLocator(),
//       ),
//     );
//   }
// }
