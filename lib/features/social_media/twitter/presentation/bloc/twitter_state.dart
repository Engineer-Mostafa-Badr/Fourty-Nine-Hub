part of 'twitter_bloc.dart';

abstract class TwitterState extends Equatable {
  const TwitterState();  

  @override
  List<Object> get props => [];
}
class TwitterInitial extends TwitterState {}
