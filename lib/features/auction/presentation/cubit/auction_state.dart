part of 'auction_cubit.dart';
class AuctionState {
  final StateStatus? status;
  final List<GetAvailableAuctionEntity>? getAvailableAuction;
  final List<GetAvailableAuctionEntity>? getExpiredAuction;
  final List<GetAvailableAuctionEntity>? getFavoriteAuction;
  final List<AuctionParticipantsEntity>? auctionParticipants;
  final List<AuctionMainCategoryEntity>? auctionMainData;
  final Failure? failure;
  final GetAvailableAuctionEntity? singleAuction;
  final List<UploadFileEntity> uploadedFiles; // store multiple uploaded files
  final bool isUploading;
  final AddFavoriteAuctionEntity? addFavoriteAuctionEntity;

  AuctionState({
    this.status,
    this.getAvailableAuction,
    this.failure,
    this.singleAuction,
    this.auctionParticipants,
    this.auctionMainData,
    this.getExpiredAuction,
    this.getFavoriteAuction,
    this.addFavoriteAuctionEntity,
    this.uploadedFiles = const [],
    this.isUploading = false,
  });

  AuctionState copyWith({
    StateStatus? status,
    List<GetAvailableAuctionEntity>? getAvailableAuction,
    Failure? failure,
    GetAvailableAuctionEntity? singleAuction,
    List<AuctionParticipantsEntity>? auctionParticipants,
    List<AuctionMainCategoryEntity>? auctionMainData,
    List<UploadFileEntity>? uploadedFiles,
    bool? isUploading,
    List<GetAvailableAuctionEntity>? getExpiredAuction,
    List<GetAvailableAuctionEntity>? getFavoriteAuction,
    AddFavoriteAuctionEntity? addFavoriteAuctionEntity,
  }) {
    return AuctionState(
      status: status ?? this.status,
      getAvailableAuction: getAvailableAuction ?? this.getAvailableAuction,
      failure: failure ?? this.failure,
      singleAuction: singleAuction ?? this.singleAuction,
      auctionParticipants: auctionParticipants ?? this.auctionParticipants,
      auctionMainData: auctionMainData ?? this.auctionMainData,
      uploadedFiles: uploadedFiles ?? this.uploadedFiles,
      isUploading: isUploading ?? this.isUploading,
      getExpiredAuction: getExpiredAuction ?? this.getExpiredAuction,
      getFavoriteAuction: getFavoriteAuction ?? this.getFavoriteAuction,
      addFavoriteAuctionEntity: addFavoriteAuctionEntity ?? this.addFavoriteAuctionEntity,
    );
  }
}



