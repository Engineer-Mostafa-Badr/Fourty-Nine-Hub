import 'package:equatable/equatable.dart';

import '../enums/base_status_enum.dart';
import '../error/failure.dart';

class BasicState<T> {
  final T? data;
  final StateStatus status;
  final Failure? failure;

  const BasicState({
    this.data,
    this.status = StateStatus.initial,
    this.failure,
  });

  @override
  String toString() {
    return 'BasicState{ data: $data, status: $status, failure: $failure,}';
  }

  BasicState<T> copyWith({
    T? data,
    StateStatus? status,
    Failure? failure,
  }) {
    return BasicState(
      data: data ?? this.data,
      status: status ?? this.status,
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
