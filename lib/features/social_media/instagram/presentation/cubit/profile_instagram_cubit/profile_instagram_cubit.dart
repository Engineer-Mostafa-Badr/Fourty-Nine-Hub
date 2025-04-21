import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/profile_instagram_data_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/reels_specific_user_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_instagram_profile_use_case.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_instagram_reels_specific_user_use_case.dart';

part 'profile_instagram_state.dart';

class ProfileInstagramCubit extends Cubit<ProfileInstagramState> {
  ProfileInstagramCubit(this.getInstagramProfileUseCase,
      this.getInstagramReelsSpecificUserUseCase)
      : super(const ProfileInstagramState());

  final GetInstagramProfileUseCase getInstagramProfileUseCase;
  final GetInstagramReelsSpecificUserUseCase
      getInstagramReelsSpecificUserUseCase;

  final int postsLimit = 10;
  final int reelsLimit = 10;

  Future<void> getUserProfile({required String userId}) async {
    emit(state.copyWith(status: ProfileInstagramStatus.loading));
    final result =
        await getInstagramProfileUseCase.call(GetInstagramProfileParams(
      userId: userId,
      page: state.postsPage,
      limit: postsLimit,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
        status: ProfileInstagramStatus.failure,
        failure: failure,
      )),
      (profileData) async {
        emit(state.copyWith(
          profileData: profileData,
        ));

        final result = await getInstagramReelsSpecificUserUseCase
            .call(GetInstagramReelsSpecificUserParams(
          userId: userId,
          page: state.reelsPage,
          limit: reelsLimit,
        ));

        result.fold(
          (failure) => emit(state.copyWith(
            status: ProfileInstagramStatus.failure,
            failure: failure,
          )),
          (reelsData) {
            emit(state.copyWith(
              status: ProfileInstagramStatus.success,
              reelsData: reelsData,
            ));
          },
        );
      },
    );
  }
}
