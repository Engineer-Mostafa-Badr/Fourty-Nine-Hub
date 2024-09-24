import 'package:fourtyninehub/features/custom_page/domain/entity/social_page_entity.dart';

import '../../../../../../core/error/failure.dart';
import '../../domain/entity/sub_tab_entity.dart';

enum CustomPageStates { loading, initial, error, success}

class CustomPageState {
  final CustomPageStates status;
  final Failure? failure;
  final SocialPageEntity? social;
  final SubTabEntity? subTab;

  const CustomPageState({
    this.status = CustomPageStates.loading,
    this.failure,
    this.social,
    this.subTab
  });
  CustomPageState copyWith(
      {CustomPageStates? status,
      Failure? failure,
        SocialPageEntity? social,
        SubTabEntity? subTab
      }) {
    return CustomPageState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      social: social ?? this.social,
      subTab: subTab ?? this.subTab,
    );
  }
}
