part of 'live_streaming_bloc.dart';

abstract class LiveStreamingState extends Equatable {
  const LiveStreamingState();  

  @override
  List<Object> get props => [];
}
class LiveStreamingInitial extends LiveStreamingState {}
