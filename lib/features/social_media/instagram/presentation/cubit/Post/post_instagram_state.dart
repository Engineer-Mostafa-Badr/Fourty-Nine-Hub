import 'package:fourtyninehub/core/error/failure.dart';

class PostInstagramState {}

class InitialPostInstagramState extends PostInstagramState {}

class LoadingPostInstagramState extends PostInstagramState {}

class FailurePostInstagramState extends PostInstagramState {
  final Failure failure;

  FailurePostInstagramState({required this.failure});
}


class SuccessCreatePostInstagramState extends PostInstagramState{}