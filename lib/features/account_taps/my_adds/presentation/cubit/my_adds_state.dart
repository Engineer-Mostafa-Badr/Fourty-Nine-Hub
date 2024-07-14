part of 'my_adds_cubit.dart';

enum MyAddsStates { loading, error, initState }

class MyAddsState {
  final MyAddsStates? status;
  final Failure? failure;
  final List<AdEntity>? myAds;
  final List<TripAndRequestEntity>? comeWithMeTrips;
  final List<TripAndRequestEntity>? pickMeTrips;

  const MyAddsState(
      {this.status,
      this.failure,
      this.myAds,
      this.comeWithMeTrips,
      this.pickMeTrips});
  MyAddsState copyWith({
    MyAddsStates? status,
    Failure? failure,
    List<AdEntity>? myAds,
    List<TripAndRequestEntity>? comeWithMeTrips,
    List<TripAndRequestEntity>? pickMeTrips,
  }) {
    return MyAddsState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      myAds: myAds ?? this.myAds,
      comeWithMeTrips: comeWithMeTrips ?? this.comeWithMeTrips,
      pickMeTrips: pickMeTrips ?? this.pickMeTrips,
    );
  }
}
