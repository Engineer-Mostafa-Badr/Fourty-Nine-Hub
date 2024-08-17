import 'package:fourtyninehub/features/social_media/club_house/data/datasource/club_voice_datasource.dart';
import 'package:fourtyninehub/features/social_media/club_house/data/repositories/club_voice_repository_impl.dart';
import 'package:fourtyninehub/features/social_media/club_house/domain/repositories/club_voice_repository.dart';
import 'package:fourtyninehub/features/social_media/club_house/domain/usecases/add_club_voice_use_case.dart';
import 'package:fourtyninehub/features/social_media/club_house/presentation/controller/club_voice_bloc.dart';
import 'package:get_it/get_it.dart';

import '../features/social_media/club_house/domain/usecases/end_club_voice_use_case.dart';
import '../features/social_media/club_house/domain/usecases/get_club_voice_use_case.dart';
import '../features/social_media/club_house/domain/usecases/join_club_voice_use_case.dart';
import '../features/social_media/club_house/domain/usecases/leave_club_voice_use_case.dart';
import '../features/social_media/club_house/domain/usecases/search_club_voice_use_case.dart';

class ClubVoiceServiceLocator {
  static Future<void> execute({required GetIt serviceLocator}) async {
    //concrete class return implementation class
    serviceLocator.registerLazySingleton<ClubVoiceDataSource>(
      () => ClubVoiceDataSourceImpl(
        serviceLocator(),
      ),
    );

    serviceLocator.registerLazySingleton<ClubVoiceRepository>(
      () => ClubVoiceRepositoryImpl(
        clubVoiceDataSource: serviceLocator(),
      ),
    );
    //usecases
    serviceLocator.registerFactory(() => AddClubVoiceUseCase(serviceLocator()));
    serviceLocator.registerFactory(() => GetClubVoiceUseCase(serviceLocator()));
    serviceLocator.registerFactory(() => EndClubVoiceUseCase(serviceLocator()));
    serviceLocator
        .registerFactory(() => LeaveClubVoiceUseCase(serviceLocator()));
    serviceLocator
        .registerFactory(() => JoinClubVoiceUseCase(serviceLocator()));
    serviceLocator
        .registerFactory(() => SearchClubVoiceUseCase(serviceLocator()));
    //cubit
    serviceLocator.registerFactory(() => ClubVoiceCubit(
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
        ));
  }
}
