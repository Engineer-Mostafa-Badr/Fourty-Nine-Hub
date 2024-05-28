part of 'live_streaming_cubit.dart';

abstract class LiveStreamingState extends Equatable {
  const LiveStreamingState();

  @override
  List<Object> get props => [];
}

class LiveStreamingInitial extends LiveStreamingState {}
