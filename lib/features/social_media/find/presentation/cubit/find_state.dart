import 'package:fourtyninehub/features/social_media/find/domain/entity/find_like_entity.dart';
import '../../../../../core/error/failure.dart';
import '../../domain/entity/find_entity.dart';




enum FindStates { initial, loading, failure, success }

extension DataStateExtension on FindState {
  bool get isInitial => status == FindStates.initial;

  bool get isSuccess => status == FindStates.success;

  bool get isFailure => status == FindStates.failure;

  bool get isLoading => status == FindStates.loading;
}

  class FindState {
  final FindStates status;
  final Failure? failure;
  final bool? addedLove;

  final FindLikeEntity? tinderLikeData;
  final List<FindEntity>? findData;
  FindState({
    this.status = FindStates.initial,
    this.failure,

    this.tinderLikeData,
    this.findData,
    this.addedLove = false,
  });

  // Method to update the state
  FindState copyWith({
    FindStates? status,
    Failure? failure,

    FindLikeEntity? tinderLikeData,
    List<FindEntity>? findData,
    bool? addedLove,
  }) {
    return FindState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      tinderLikeData: tinderLikeData ?? this.tinderLikeData,
      findData: findData ?? this.findData,
      addedLove: addedLove ?? this.addedLove,
    );
  }
}
