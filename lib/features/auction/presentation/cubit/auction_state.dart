part of 'auction_cubit.dart';
class AuctionState  {
  final StateStatus? status;
  final List<GetAvailableAuctionEntity>? getAvailableAuction;
  final List<AuctionParticipantsEntity>? auctionParticipants;
  final Failure? failure;
  final GetAvailableAuctionEntity? singleAuction;

  AuctionState (
      {
         this.status,
        this.getAvailableAuction,
        this.failure,
        this.singleAuction,
        this.auctionParticipants,
      });

  AuctionState  copyWith({
    StateStatus? status,
    List<GetAvailableAuctionEntity>? getAvailableAuction,
    Failure? failure,
    GetAvailableAuctionEntity? singleAuction,
    List<AuctionParticipantsEntity>? auctionParticipants,
  }) {
    return AuctionState (
      status: status ?? this.status,
      getAvailableAuction: getAvailableAuction ?? this.getAvailableAuction,
      failure: failure ?? this.failure,
      singleAuction: singleAuction ?? this.singleAuction,
      auctionParticipants: auctionParticipants ?? this.auctionParticipants,
    );
  }
}

