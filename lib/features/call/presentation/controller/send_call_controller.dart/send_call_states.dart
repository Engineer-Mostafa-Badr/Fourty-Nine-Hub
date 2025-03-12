import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/features/call/domain/entities/call_data.dart';

abstract class SendCallState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SendCallInitial extends SendCallState {}

class SendCallLoading extends SendCallState {}

class UnableSendCall extends SendCallState {
  final String reason;

  UnableSendCall({required this.reason});

  @override
  List<Object?> get props => [reason];
}

class CallRinging extends SendCallState {
  final CallData callData;

  CallRinging({required this.callData});

  @override
  List<Object?> get props => [callData];
}

class CallConnected extends SendCallState {}

class FakeCallConnected extends SendCallState {}

class DeclinedCall extends SendCallState {}