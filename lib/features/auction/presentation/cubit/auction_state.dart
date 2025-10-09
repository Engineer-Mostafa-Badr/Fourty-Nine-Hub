part of 'auction_cubit.dart';
class AuctionState {
  final StateStatus? status;
  final StateStatus? participantsStatus;  // 👈 new
  final List<GetAvailableAuctionEntity>? getAvailableAuction;
  final List<GetAvailableAuctionEntity>? getExpiredAuction;
  final List<GetAvailableAuctionEntity>? getFavoriteAuction;
  final List<GetAvailableAuctionEntity>? getMyAuction;
  final List<GetAvailableAuctionEntity>? searchAuction;
  final List<AuctionParticipantsEntity>? auctionParticipants;
  final List<AuctionMainCategoryEntity>? auctionMainData;
  final Failure? failure;
  final GetAvailableAuctionEntity? singleAuction;
  final List<UploadFileEntity> uploadedFiles; // store multiple uploaded files
  final bool isUploading;
  final bool isLoading;
  final AddFavoriteAuctionEntity? addFavoriteAuctionEntity;
  final CreateAuctionEntity ? createAuction;
  final BidErrorEntity? bidError;
  final BidWinnerEntity? bidWinner; // 👑 new field
  final List<MyBiddersEntity>? myBiddersData;
  final AuctionBannerEntity? auctionBanner;
  final AuctionWinnerDataEntity? auctionWinnerData;
  final List<ViewerEntity>? auctionViewerData;
  AuctionState({
    this.status,
    this.participantsStatus, // 👈 add
    this.getAvailableAuction,
    this.failure,
    this.singleAuction,
    this.auctionParticipants,
    this.auctionMainData,
    this.getExpiredAuction,
    this.getFavoriteAuction,
    this.addFavoriteAuctionEntity,
    this.getMyAuction,
    this.bidError,
    this.bidWinner,
    this.auctionWinnerData,
    this.createAuction,
    this.myBiddersData,
    this.auctionBanner,
    this.searchAuction,
    this.uploadedFiles = const [],
    this.isUploading = false,
    this.isLoading = false,
    this.auctionViewerData ,
  });

  AuctionState copyWith({
    StateStatus? status,
    StateStatus? participantsStatus, // 👈 add
    List<GetAvailableAuctionEntity>? getAvailableAuction,
    List<GetAvailableAuctionEntity>? searchAuction,
    Failure? failure,
    GetAvailableAuctionEntity? singleAuction,
    List<AuctionParticipantsEntity>? auctionParticipants,
    List<AuctionMainCategoryEntity>? auctionMainData,
    List<UploadFileEntity>? uploadedFiles,
    bool? isUploading,
    bool? isLoading,
    List<GetAvailableAuctionEntity>? getExpiredAuction,
    List<GetAvailableAuctionEntity>? getFavoriteAuction,
    AddFavoriteAuctionEntity? addFavoriteAuctionEntity,
    List<GetAvailableAuctionEntity>? getMyAuction,
    BidErrorEntity? bidError,
    BidWinnerEntity? bidWinner,
    CreateAuctionEntity ? createAuction,
    List<MyBiddersEntity>? myBiddersData,
    AuctionBannerEntity? auctionBanner,
    AuctionWinnerDataEntity? auctionWinnerData,
    List<ViewerEntity>? auctionViewerData,
  }) {
    return AuctionState(
      status: status ?? this.status,
      participantsStatus: participantsStatus ?? this.participantsStatus, // 👈
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
      getMyAuction: getMyAuction ?? this.getMyAuction,
      bidError: bidError ?? this.bidError,
      bidWinner: bidWinner ?? this.bidWinner,
      createAuction: createAuction ?? this.createAuction,
      myBiddersData: myBiddersData ?? this.myBiddersData,
      auctionBanner: auctionBanner ?? this.auctionBanner,
      isLoading: isLoading ?? this.isLoading,
      auctionWinnerData: auctionWinnerData ?? this.auctionWinnerData,
      searchAuction: searchAuction ?? this.searchAuction,
      auctionViewerData: auctionViewerData ?? this.auctionViewerData,
    );
  }
}
