part of 'my_adds_cubit.dart';

enum MyAddsStates { loading, error, initState }

class MyAddsState {
  final MyAddsStates? status;
  final Failure? failure;
  final List<AdEntity>? myAds;
  const MyAddsState({this.status, this.failure, this.myAds});
  MyAddsState copyWith(
    {
       MyAddsStates? status,
   Failure? failure,
   List<AdEntity>? myAds,
    }
  ) {
    return MyAddsState(
      status: status?? this.status,
      failure:  failure?? this.failure,
      myAds: myAds?? this.myAds,
    );
  }
}
