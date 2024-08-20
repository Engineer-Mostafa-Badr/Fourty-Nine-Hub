part of 'auction_details_cubit.dart';

enum AuctionDetailsStates { loading, initState, error, success }

extension AuctionDetailsStateX on AuctionDetailsState {
  bool get isLoading => status == AuctionDetailsStates.loading;
  bool get isInitState => status == AuctionDetailsStates.initState;
  bool get isError => status == AuctionDetailsStates.error;
  bool get isSuccess => status == AuctionDetailsStates.success;
}

class AuctionDetailsState {
  final AuctionDetailsStates status;
  final Failure? failure;
  final AuctionEntity? auction;
  final String? successMessage;
  const AuctionDetailsState(
      {this.auction,
      this.failure,
      this.successMessage,
      this.status = AuctionDetailsStates.loading});
  AuctionDetailsState copyWith({
    AuctionDetailsStates? status,
    Failure? failure,
    AuctionEntity? auction,
    String? successMessage,
  }) {
    return AuctionDetailsState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      auction: auction ?? this.auction,
      successMessage: successMessage ?? this.successMessage,
    );
  }
}
