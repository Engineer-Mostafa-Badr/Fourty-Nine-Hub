// lib/features/star_feature/presentation/controllers/cubits/profile_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../routes/pages.dart';
import '../../../domain/entity/profile_entity.dart';
import '../../../domain/use_case/get_my_profile_use_case.dart';
import '../../../domain/use_case/get_profile_by_id_use_case.dart';
import '../../../domain/use_case/update_profile_use_case.dart';
import '../../utils/enums.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/entity/profile_entity.dart';
import '../../utils/enums.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetMyProfileUseCase _getMyProfileUseCase;
  final GetProfileByIdUseCase _getProfileByIdUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;

  ProfileCubit(
    this._getMyProfileUseCase,
    this._getProfileByIdUseCase,
    this._updateProfileUseCase,
  ) : super(const ProfileState());

  // Get my profile with loading state
  Future<void> getMyProfile({bool showLoading = true}) async {
    if (isClosed) return; // إضافة هذا التحقق

    if (showLoading) {
      emit(state.copyWith(status: ProfileStatus.loading));
    }

    final result = await _getMyProfileUseCase(const NoParams());

    if (isClosed) return; // إضافة هذا التحقق أيضاً

    result.fold(
      (failure) {
        if (!isClosed) {
          emit(state.copyWith(
            status: ProfileStatus.error,
            failure: failure,
          ));
          _showErrorMessage(failure);
        }
      },
      (profile) {
        if (!isClosed) {
          emit(state.copyWith(
            status: ProfileStatus.success,
            profile: profile,
            failure: null,
          ));
        }
      },
    );
  }

  // Get profile by ID (new method)
  Future<void> getProfileById(String profileId,
      {bool showLoading = true}) async {
    if (isClosed) return;

    if (showLoading) {
      emit(state.copyWith(status: ProfileStatus.loading));
    }

    final result = await _getProfileByIdUseCase(profileId);

    if (isClosed) return;

    result.fold(
      (failure) {
        if (!isClosed) {
          emit(state.copyWith(
            status: ProfileStatus.error,
            failure: failure,
          ));
          _showErrorMessage(failure);
        }
      },
      (profile) {
        if (!isClosed) {
          emit(state.copyWith(
            status: ProfileStatus.success,
            profile: profile,
            failure: null,
          ));
        }
      },
    );
  }

  // Subscribe/Unsubscribe methods (إضافة جديدة)
  Future<void> toggleSubscription(String profileId) async {
    // إضافة الـ API call للاشتراك/إلغاء الاشتراك
    // يمكن إضافة endpoint منفصل لده لاحقاً
  }

  // Update profile with validation
  Future<bool> updateProfile({
    required String channelName,
    required String channelDescription,
    String? channelCover,
    String? channelPicture,
  }) async {
    // Basic validation
    if (channelName.trim().isEmpty) {
      _showErrorMessage(ValidationFailure());
      return false;
    }

    if (channelDescription.trim().isEmpty) {
      _showErrorMessage(ValidationFailure());
      return false;
    }

    emit(state.copyWith(status: ProfileStatus.updating));

    final params = UpdateProfileParams(
      channelName: channelName.trim(),
      channelDescription: channelDescription.trim(),
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
        ProfileEntity? updatedProfile;
        if (state.profile != null) {
          updatedProfile = state.profile!.copyWith(
            channelName: channelName.trim(),
            channelDescription: channelDescription.trim(),
            // Note: You might want to handle media updates differently
            // based on your ProfileEntity structure
          );
        }

        emit(state.copyWith(
          status: ProfileStatus.success,
          profile: updatedProfile ?? state.profile,
          message: message,
          failure: null, // Clear previous errors
        ));

        _showSuccessMessage(message);
        return true;
      },
    );
  }

  // Refresh profile data silently
  Future<void> refreshProfile() async {
    await getMyProfile(showLoading: false);
  }

  // Clear any messages or errors
  void clearMessage() {
    emit(state.copyWith(
      message: null,
      failure: null,
    ));
  }

  // Clear error state
  void clearError() {
    emit(state.copyWith(
      failure: null,
      status:
          state.profile != null ? ProfileStatus.success : ProfileStatus.initial,
    ));
  }

  // Reset to initial state
  void reset() {
    emit(const ProfileState());
  }

  // Check if profile is complete
  bool get isProfileComplete {
    final profile = state.profile;
    if (profile == null) return false;

    return profile.channelName.isNotEmpty &&
        profile.channelDescription.isNotEmpty;
  }

  // Get profile completion percentage
  double get profileCompletionPercentage {
    final profile = state.profile;
    if (profile == null) return 0.0;

    double completion = 0.0;
    const double fieldWeight = 0.25; // Each field is worth 25%

    if (profile.channelName.isNotEmpty) completion += fieldWeight;
    if (profile.channelDescription.isNotEmpty) completion += fieldWeight;
    // Add more fields as needed
    // if (profile.channelCover != null) completion += fieldWeight;
    // if (profile.channelPicture != null) completion += fieldWeight;

    return completion.clamp(0.0, 1.0);
  }

  void _showErrorMessage(Failure failure) {
    final currentContext =
        AppPages.router.configuration.navigatorKey.currentContext;
    if (currentContext != null) {
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
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

// Custom failure for validation
class ValidationFailure extends Failure {
  const ValidationFailure() : super();
}
