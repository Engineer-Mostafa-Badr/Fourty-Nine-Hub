import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/share_app/domain/entity/share_app_entity.dart';

enum ShareAppStates { loading, error, initState, success, imageUploading }

class ShareAppState {
  final ShareAppStates? status;
  final Failure? failure;
  final ShareAppEntity? shareApp;

  const ShareAppState({this.status, this.failure, this.shareApp});
  ShareAppState copyWith(
      {ShareAppStates? status, Failure? failure, ShareAppEntity? shareApp}) {
    return ShareAppState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      shareApp: shareApp ?? this.shareApp,
    );
  }
}
