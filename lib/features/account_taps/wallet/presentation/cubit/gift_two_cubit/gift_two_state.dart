part of 'gift_two_cubit.dart';

enum GiftTwoStates { loading, initial, failure, success }

extension GiftTwoStateX on GiftTwoStates {
  bool get isInitial => this == GiftTwoStates.initial;
  bool get isLoading => this == GiftTwoStates.loading;
  bool get isSuccess => this == GiftTwoStates.success;
  bool get isFailure => this == GiftTwoStates.failure;
}

class GiftTwoState {
  final GiftTwoStates status;
  final GiftAndCompetitionEntity? giftAndCompetitionEntity;
  // final GiftWalletEntity? giftEntity;
  // final List<GiftCompetitionEntity>? giftCompetitionEntity;
  final String? errMessage;
  final bool? buttonRequestFiveLoading;
  final bool? buttonRequestTenLoading;

  const GiftTwoState({
    this.status = GiftTwoStates.initial,
    this.giftAndCompetitionEntity,
    // this.giftEntity,
    // this.giftCompetitionEntity,
    this.errMessage,
    this.buttonRequestFiveLoading,
    this.buttonRequestTenLoading,

});

  GiftTwoState copyWith({
    GiftTwoStates? status,
    GiftAndCompetitionEntity? giftAndCompetitionEntity,
    // GiftWalletEntity? giftEntity,
    // List<GiftCompetitionEntity>? giftCompetitionEntity,
    String? errMessage,
    bool? buttonRequestFiveLoading,
    bool? buttonRequestTenLoading,
  }) {
    return GiftTwoState(
      status: status ?? this.status,
      giftAndCompetitionEntity: giftAndCompetitionEntity?? this.giftAndCompetitionEntity,
      // giftEntity: giftEntity ?? this.giftEntity,
      // giftCompetitionEntity: giftCompetitionEntity ?? this.giftCompetitionEntity,
      errMessage: errMessage ?? this.errMessage,
        buttonRequestFiveLoading: buttonRequestFiveLoading ?? this.buttonRequestFiveLoading,
        buttonRequestTenLoading: buttonRequestTenLoading ?? this.buttonRequestTenLoading
    );
  }
}

// sealed class GiftTwoState extends Equatable {
//   const GiftTwoState();
//
//   @override
//   List<Object> get props => [];
// }
//
// final class GiftTwoInitial extends GiftTwoState {}
//
// final class GiftTwoLoading extends GiftTwoState {}
//
// final class GiftTwoSuccess extends GiftTwoState {
//   final GiftWalletEntity giftEntity;
//   final List<GiftCompetitionEntity> giftCompetitionEntity;
//
//   const GiftTwoSuccess({
//     required this.giftEntity,
//     required this.giftCompetitionEntity,
//   });
// }
//
// final class GiftTwoFailure extends GiftTwoState {
//   final String message;
//
//   const GiftTwoFailure({required this.message});
// }
