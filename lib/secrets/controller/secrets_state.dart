import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../domain/entities/secrets.dart';

enum SecretsStateStatus {
  initial,
  loading,
  failure,
  success,
}

extension SecretsStateX on SecretsState {
  bool get isInitial => status == SecretsStateStatus.initial;
  bool get isLoading => status == SecretsStateStatus.loading;

  bool get isSuccess => status == SecretsStateStatus.success;

  bool get isFailure => status == SecretsStateStatus.failure;
}

class SecretsState extends Equatable {
  final Failure? failure;
  final Secrets? secrets;
  final SecretsStateStatus status;

  const SecretsState({
    this.failure,
    this.secrets,
    this.status = SecretsStateStatus.initial,
  });

  SecretsState copyWith({
    Failure? failure,
    Secrets? secrets,
    SecretsStateStatus? status,
  }) {
    return SecretsState(
      failure:failure ?? this.failure,
      secrets:secrets ?? this.secrets,
      status:status ?? this.status,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [failure, secrets, status];
}
