import 'package:fourtyninehub/features/zoom/domain/usecases/get_scheuled_rooms_use_case.dart';
import 'package:get_it/get_it.dart';

import '../features/zoom/data/data_source/meeting_data_source.dart';
import '../features/zoom/data/repository/meeting_repository_impl.dart';
import '../features/zoom/domain/repositories/meeting_repository.dart';
import '../features/zoom/domain/usecases/add_room_use_case.dart';
import '../features/zoom/domain/usecases/join_room_use_case.dart';
import '../features/zoom/domain/usecases/end_room_use_case.dart';
import '../features/zoom/presentation/controller/stream_cubit.dart';

class MeetingServiceLocator {
  static Future<void> execute({required GetIt serviceLocator}) async {
    //concrete class return implementation class
    serviceLocator.registerLazySingleton<MeetingDataSource>(
      () => MeetingDataSourceImpl(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<MeetingRepository>(
      () => MeetingRepositoryImpl(
        serviceLocator(),
      ),
    );
    //usecases
    serviceLocator.registerFactory(() => AddRoomUseCase(serviceLocator()));
    serviceLocator.registerFactory(() => JoinRoomUseCase(serviceLocator()));
    serviceLocator.registerFactory(() => EndRoomUseCase(serviceLocator()));
    serviceLocator
        .registerFactory(() => GetScheduledRoomsUseCase(serviceLocator()));
    //cubit
    serviceLocator.registerFactory(() => StreamCubit(
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
        ));
  }
}
