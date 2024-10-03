part of 'my_adds_cubit.dart';

enum MyAddsStates { loading, error, initState, success }

class MyAddsState {
  final MyAddsStates? status;
  final Failure? failure;
  final List<AdEntity>? myAds;
  final List<TripAndRequestEntity>? comeWithMeTrips;
  final List<TripAndRequestEntity>? pickMeTrips;
  final List<MyAuctionAdsEntity>? myAuctions;
  final List<MyAuctionAdsEntity>? myInstallments;
  final MyAdsTripJoinEntity? tripJoin;

  const MyAddsState(
      {this.status,
      this.failure,
      this.myAds,
      this.comeWithMeTrips,
      this.pickMeTrips,
      this.myAuctions,
      this.myInstallments,
      this.tripJoin});
  MyAddsState copyWith(
      {MyAddsStates? status,
      Failure? failure,
      List<AdEntity>? myAds,
      List<TripAndRequestEntity>? comeWithMeTrips,
      List<TripAndRequestEntity>? pickMeTrips,
      List<MyAuctionAdsEntity>? myAuctions,
      List<MyAuctionAdsEntity>? myInstallments,
      MyAdsTripJoinEntity? tripJoin}) {
    return MyAddsState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      myAds: myAds ?? this.myAds,
      comeWithMeTrips: comeWithMeTrips ?? this.comeWithMeTrips,
      pickMeTrips: pickMeTrips ?? this.pickMeTrips,
      myAuctions: myAuctions ?? this.myAuctions,
      myInstallments: myInstallments ?? this.myInstallments,
      tripJoin: tripJoin ?? this.tripJoin,
    );
  }
}
