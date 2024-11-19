part of 'my_adds_cubit.dart';

enum MyAddsStates { loading, error, initState, success, imageUploading }

class MyAddsState {
  final MyAddsStates? status;
  final Failure? failure;
  final List<AdEntity>? myAds;
  final List<TripAndRequestEntity>? comeWithMeTrips;
  final List<TripAndRequestEntity>? pickMeTrips;
  final List<MyAuctionAdsEntity>? myAuctions;
  final List<MyAuctionAdsEntity>? myInstallments;
  final List<MyAuctionAdsEntity>? myOtherAds;
  final List<GetAllCountsTripJoinEntity>? allCounts;
  final MyAdsTripJoinEntity? tripJoin;
  final List<GetAllCountAdsEntity>? countAds;
  final List<UploadFileEntity>? images;
  final ClickEntity? click;
  final EditMyAdsEntity? adsById;

  const MyAddsState({
    this.status,
    this.failure,
    this.myAds,
    this.comeWithMeTrips,
    this.pickMeTrips,
    this.myAuctions,
    this.myInstallments,
    this.tripJoin,
    this.myOtherAds,
    this.allCounts,
    this.countAds,
    this.images,
    this.click,
    this.adsById,
  });
  MyAddsState copyWith({
    MyAddsStates? status,
    Failure? failure,
    List<AdEntity>? myAds,
    List<TripAndRequestEntity>? comeWithMeTrips,
    List<TripAndRequestEntity>? pickMeTrips,
    List<MyAuctionAdsEntity>? myAuctions,
    List<MyAuctionAdsEntity>? myInstallments,
    List<MyAuctionAdsEntity>? myOtherAds,
    List<GetAllCountsTripJoinEntity>? allCounts,
    MyAdsTripJoinEntity? tripJoin,
    List<GetAllCountAdsEntity>? countAds,
    List<UploadFileEntity>? images,
    ClickEntity? click,
    EditMyAdsEntity? adsById,
  }) {
    return MyAddsState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      myAds: myAds ?? this.myAds,
      comeWithMeTrips: comeWithMeTrips ?? this.comeWithMeTrips,
      pickMeTrips: pickMeTrips ?? this.pickMeTrips,
      myAuctions: myAuctions ?? this.myAuctions,
      myInstallments: myInstallments ?? this.myInstallments,
      tripJoin: tripJoin ?? this.tripJoin,
      myOtherAds: myOtherAds ?? this.myOtherAds,
      allCounts: allCounts ?? this.allCounts,
      countAds: countAds ?? this.countAds,
      images: images ?? this.images,
      click: click ?? this.click,
      adsById: adsById ?? this.adsById,
    );
  }
}
