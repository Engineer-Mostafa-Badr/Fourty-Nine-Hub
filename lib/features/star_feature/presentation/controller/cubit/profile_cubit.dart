import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../routes/pages.dart';
import '../../../data/repository/profile_repository.dart';
import '../../../domain/entity/profile_entity.dart';
import '../../../domain/use_case/get_my_profile_use_case.dart';
import '../../../domain/use_case/update_profile_use_case.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetMyProfileUseCase _getMyProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;

  ProfileCubit(
    this._getMyProfileUseCase,
    this._updateProfileUseCase,
  ) : super(const ProfileState());

  // Get my profile
  Future<void> getMyProfile() async {
    emit(state.copyWith(status: ProfileStatus.loading));

    final result = await _getMyProfileUseCase(const NoParams());

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: ProfileStatus.error,
          failure: failure,
        ));
        _showErrorMessage(failure);
      },
      (profile) {
        emit(state.copyWith(
          status: ProfileStatus.success,
          profile: profile,
        ));
      },
    );
  }

  // Update profile
  Future<bool> updateProfile({
    required String channelName,
    required String channelDescription,
    String? channelCover,
    String? channelPicture,
  }) async {
    emit(state.copyWith(status: ProfileStatus.updating));

    final params = UpdateProfileParams(
      channelName: channelName,
      channelDescription: channelDescription,
      channelCover: channelCover,
      channelPicture: channelPicture,
    );

    final result = await _updateProfileUseCase(params);

    return result.fold(
      (failure) {
        emit(state.copyWith(
          status: ProfileStatus.error,
          failure: failure,
        ));
        _showErrorMessage(failure);
        return false;
      },
      (message) {
        // Update local profile with new data
        if (state.profile != null) {
          final updatedProfile = state.profile!.copyWith(
            channelName: channelName,
            channelDescription: channelDescription,
            // Note: channelCover and channelPicture would need to be converted
            // from IDs to MediaEntity objects if you want to update them locally
          );

          emit(state.copyWith(
            status: ProfileStatus.success,
            profile: updatedProfile,
            message: message,
          ));
        } else {
          emit(state.copyWith(
            status: ProfileStatus.success,
            message: message,
          ));
        }

        _showSuccessMessage(message);
        return true;
      },
    );
  }

  // Clear any messages
  void clearMessage() {
    emit(state.copyWith(message: null));
  }

  // Refresh profile data
  Future<void> refreshProfile() async {
    await getMyProfile();
  }

  void _showErrorMessage(Failure failure) {
    final currentContext =
        AppPages.router.configuration.navigatorKey.currentContext;
    if (currentContext != null) {
      showErrorMessage(
        currentContext,
        getFailureMessage(failure, currentContext),
      );
    }
  }

  void _showSuccessMessage(String message) {
    final currentContext =
        AppPages.router.configuration.navigatorKey.currentContext;
    if (currentContext != null) {
      showSuccessMessage(currentContext, message);
    }
  }
}
