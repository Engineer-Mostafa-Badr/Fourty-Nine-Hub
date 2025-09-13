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
import '../../../domain/use_case/subscribe_to_channel_use_case.dart';
import '../../../domain/use_case/unsubscribe_from_channel_use_case.dart';
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
  final SubscribeToChannelUseCase _subscribeToChannelUseCase; // NEW
  final UnsubscribeFromChannelUseCase _unsubscribeFromChannelUseCase; // NEW

  ProfileCubit(
    this._getMyProfileUseCase,
    this._getProfileByIdUseCase,
    this._updateProfileUseCase,
    this._subscribeToChannelUseCase, // NEW
    this._unsubscribeFromChannelUseCase, // NEW
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

  Future<bool> subscribeToChannel(String profileId) async {
    if (isClosed) return false;

    print('🔔 Subscribing to channel: $profileId');

    final result = await _subscribeToChannelUseCase(profileId);

    if (isClosed) return false;

    return result.fold(
      (failure) {
        print('❌ Subscription failed: $failure');
        _showErrorMessage(failure);
        return false;
      },
      (message) {
        print('✅ Subscription successful: $message');

        // Update local profile state to reflect subscription
        if (state.profile != null) {
          final updatedProfile = state.profile!.copyWith(
            isSubscribed: true,
            subscribersCount: state.profile!.subscribersCount + 1,
          );

          emit(state.copyWith(
            profile: updatedProfile,
            message: message,
          ));
        }

        _showSuccessMessage(message);
        return true;
      },
    );
  }

  // NEW: Unsubscribe from channel
  Future<bool> unsubscribeFromChannel(String profileId) async {
    if (isClosed) return false;

    print('🔕 Unsubscribing from channel: $profileId');

    final result = await _unsubscribeFromChannelUseCase(profileId);

    if (isClosed) return false;

    return result.fold(
      (failure) {
        print('❌ Unsubscription failed: $failure');
        _showErrorMessage(failure);
        return false;
      },
      (message) {
        print('✅ Unsubscription successful: $message');

        // Update local profile state to reflect unsubscription
        if (state.profile != null) {
          final updatedProfile = state.profile!.copyWith(
            isSubscribed: false,
            subscribersCount: state.profile!.subscribersCount - 1,
          );

          emit(state.copyWith(
            profile: updatedProfile,
            message: message,
          ));
        }

        _showSuccessMessage(message);
        return true;
      },
    );
  }

  // NEW: Toggle subscription status
  Future<bool> toggleSubscription(String profileId) async {
    if (state.profile?.isSubscribed == true) {
      return await unsubscribeFromChannel(profileId);
    } else {
      return await subscribeToChannel(profileId);
    }
  }

  // Update profile with validation - Enhanced version
  Future<bool> updateProfile({
    required String channelName,
    required String channelDescription,
    String? channelCover,
    String? channelPicture,
  }) async {
    if (isClosed) return false;

    // Basic validation
    if (channelName.trim().isEmpty) {
      _showErrorMessage(ValidationFailure('Channel name cannot be empty'));
      return false;
    }

    if (channelDescription.trim().isEmpty) {
      _showErrorMessage(
          ValidationFailure('Channel description cannot be empty'));
      return false;
    }

    emit(state.copyWith(status: ProfileStatus.updating));

    final params = UpdateProfileParams(
      channelName: channelName.trim(),
      channelDescription: channelDescription.trim(),
      channelCover: channelCover,
      channelPicture: channelPicture,
    );

    print('🔄 Updating profile...');
    print('📝 Channel Name: ${channelName.trim()}');
    print('📝 Description: ${channelDescription.trim()}');
    print('🖼️ Cover ID: ${channelCover ?? 'no change'}');
    print('👤 Picture ID: ${channelPicture ?? 'no change'}');

    final result = await _updateProfileUseCase(params);

    if (isClosed) return false;

    return result.fold(
      (failure) {
        print('❌ Profile update failed: $failure');
        emit(state.copyWith(
          status: ProfileStatus.error,
          failure: failure,
        ));
        _showErrorMessage(failure);
        return false;
      },
      (message) {
        print('✅ Profile updated successfully');

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

        // Refresh profile to get updated images from server
        refreshProfile();

        return true;
      },
    );
  }

  // Update only cover photo
  Future<bool> updateCoverPhoto(String mediaId) async {
    if (isClosed) return false;

    final currentProfile = state.profile;
    if (currentProfile == null) {
      _showErrorMessage(ValidationFailure('Profile not loaded'));
      return false;
    }

    print('📸 Updating cover photo with media ID: $mediaId');

    return await updateProfile(
      channelName: currentProfile.channelName,
      channelDescription: currentProfile.channelDescription,
      channelCover: mediaId,
      channelPicture: null, // Don't change profile picture
    );
  }

  // Update only profile picture
  Future<bool> updateProfilePicture(String mediaId) async {
    if (isClosed) return false;

    final currentProfile = state.profile;
    if (currentProfile == null) {
      _showErrorMessage(ValidationFailure('Profile not loaded'));
      return false;
    }

    print('👤 Updating profile picture with media ID: $mediaId');

    return await updateProfile(
      channelName: currentProfile.channelName,
      channelDescription: currentProfile.channelDescription,
      channelCover: null, // Don't change cover
      channelPicture: mediaId,
    );
  }

  // Remove cover photo
  Future<bool> removeCoverPhoto() async {
    if (isClosed) return false;

    final currentProfile = state.profile;
    if (currentProfile == null) {
      _showErrorMessage(ValidationFailure('Profile not loaded'));
      return false;
    }

    print('🗑️ Removing cover photo');

    return await updateProfile(
      channelName: currentProfile.channelName,
      channelDescription: currentProfile.channelDescription,
      channelCover: "", // Empty string to remove
      channelPicture: null, // Don't change profile picture
    );
  }

  // Remove profile picture
  Future<bool> removeProfilePicture() async {
    if (isClosed) return false;

    final currentProfile = state.profile;
    if (currentProfile == null) {
      _showErrorMessage(ValidationFailure('Profile not loaded'));
      return false;
    }

    print('🗑️ Removing profile picture');

    return await updateProfile(
      channelName: currentProfile.channelName,
      channelDescription: currentProfile.channelDescription,
      channelCover: null, // Don't change cover
      channelPicture: "", // Empty string to remove
    );
  }

  // Refresh profile data silently
  Future<void> refreshProfile() async {
    await getMyProfile(showLoading: false);
  }

  // Clear any messages or errors
  void clearMessage() {
    if (isClosed) return;
    emit(state.copyWith(
      message: null,
      failure: null,
    ));
  }

  // Clear error state
  void clearError() {
    if (isClosed) return;
    emit(state.copyWith(
      failure: null,
      status:
          state.profile != null ? ProfileStatus.success : ProfileStatus.initial,
    ));
  }

  // Reset to initial state
  void reset() {
    if (isClosed) return;
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
    if (profile.channelCover != null &&
        profile.channelCover!.mediaKey.isNotEmpty) {
      completion += fieldWeight;
    }
    if (profile.channelPicture != null &&
        profile.channelPicture!.mediaKey.isNotEmpty) {
      completion += fieldWeight;
    }

    return completion.clamp(0.0, 1.0);
  }

  // Get cover photo URL
  String? get coverPhotoUrl {
    return state.profile?.channelCover?.mediaKey;
  }

  // Get profile picture URL
  String? get profilePictureUrl {
    return state.profile?.channelPicture?.mediaKey;
  }

  // Check if has cover photo
  bool get hasCoverPhoto {
    final coverUrl = coverPhotoUrl;
    return coverUrl != null && coverUrl.isNotEmpty;
  }

  // Check if has profile picture
  bool get hasProfilePicture {
    final pictureUrl = profilePictureUrl;
    return pictureUrl != null && pictureUrl.isNotEmpty;
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
  final String message;
  const ValidationFailure(this.message) : super();

  @override
  String toString() => message;
}
