import 'package:fourtyninehub/features/authentication/domain/entities/user_tokens_entity.dart';

import '../enums/base_status_enum.dart';
import '../error/failure.dart';

class BasicState<T> {
  final T? data;
  final UserTokensEntity? token;
  final StateStatus status;
  final Failure? failure;

  const BasicState({
    this.token,
    this.data,
    this.status = StateStatus.initial,
    this.failure,
  });

  @override
  String toString() {
    return 'BasicState{ data: $data ,data: ${token!.accessToken}, status: $status, failure: $failure,}';
  }

  BasicState<T> copyWith({
    T? data,
    UserTokensEntity? token,
    StateStatus? status,
    Failure? failure,
  }) {
    return BasicState(
      data: data ?? this.data,
      status: status ?? this.status,
      token: token ?? this.token,
      failure: failure ?? this.failure,
    );
  }
}

extension BasicStateX on BasicState {
  bool get isLoading => StateStatus.loading == status;

  bool get isInitial => StateStatus.initial == status;

  bool get isError => StateStatus.error == status;

  bool get isSuccess => StateStatus.success == status;
}
