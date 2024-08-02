// import 'package:fourtyninehub/features/social_media/tinder/domain/repositories/tinder_repository.dart';
// import 'package:get_it/get_it.dart';
// import 'package:http/http.dart' as http;
// import 'package:fourtyninehub/features/social_media/tinder/data/data_sources/tinder_remote_data_source.dart';
// import 'package:fourtyninehub/features/social_media/tinder/data/repositories/tinder_repository.dart';
// import 'package:fourtyninehub/features/social_media/tinder/domain/use_cases/fetch_users.dart';
// import 'package:fourtyninehub/features/social_media/tinder/domain/use_cases/fetch_subcategories.dart';
// import 'package:fourtyninehub/features/social_media/tinder/presentation/cubit/tinder_cubit.dart';
//
// final sl = GetIt.instance;
//
// void setupLocator() {
//   // Register http client
//   sl.registerLazySingleton<http.Client>(() => http.Client());
//
//   // Register data sources
//   sl.registerLazySingleton<TinderRemoteDataSource>(() => TinderRemoteDataSource(client: sl()));
//
//   // Register repositories
//   sl.registerLazySingleton<TinderRepository>(() => TinderRepositoryImpl(sl()));
//
//   // Register use cases
//   sl.registerLazySingleton(() => FetchUsers(sl()));
//   sl.registerLazySingleton(() => FetchSubcategories(sl()));
//
//   // Register cubit
//   sl.registerFactory(() => TinderCubit(fetchUsers: sl(), fetchSubcategories: sl()));
// }
