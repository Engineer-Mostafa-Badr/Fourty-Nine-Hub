// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/features/zoom/domain/entities/room_response.dart';

enum MeetingStates {
  initial,
  loading,
  success,
  failure,
  openWhiteBoard,
  minimizing
}

extension MeetingStateX on MeetingState {
  bool get isInitial => status == MeetingStates.initial;
  bool get isLoading => status == MeetingStates.loading;
  bool get isSuccess => status == MeetingStates.success;
  bool get isFailure => status == MeetingStates.failure;
  bool get isOpenWhiteBoard => status == MeetingStates.openWhiteBoard;
  bool get isMinimizing => status == MeetingStates.minimizing;
}

class MeetingState extends Equatable {
  final MeetingStates? status;
  final RoomResponseError? errorMessage;
  const MeetingState({
    this.status = MeetingStates.initial,
    this.errorMessage,
  });

  MeetingState copyWith({
    MeetingStates? status,
    RoomResponseError? errorMessage,
  }) =>
      MeetingState(
        status: status,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props => [
        status,
        errorMessage,
      ];
}
