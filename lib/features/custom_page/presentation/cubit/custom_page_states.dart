import 'package:fourtyninehub/features/custom_page/domain/entity/social_page_entity.dart';

import '../../../../../../core/error/failure.dart';

enum CustomPageStates { loading, initial, error, success}

class CustomPageState {
  final CustomPageStates status;
  final Failure? failure;
  final SocialPageEntity? social;

  const CustomPageState({
    this.status = CustomPageStates.loading,
    this.failure,
    this.social,
  });
  CustomPageState copyWith(
      {CustomPageStates? status,
      Failure? failure,
        SocialPageEntity? social
      }) {
    return CustomPageState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      social: social ?? this.social,

    );
  }
}
