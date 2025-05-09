part of 'save_post_instagram_cubit.dart';

enum SavePostInstagramStatus { initial, loading, success, failure }

extension SavePostInstagramStatusX on SavePostInstagramStatus {
  bool get isInitial => this == SavePostInstagramStatus.initial;
  bool get isLoading => this == SavePostInstagramStatus.loading;
  bool get isSuccess => this == SavePostInstagramStatus.success;
  bool get isFailure => this == SavePostInstagramStatus.failure;
}

class SavePostInstagramState extends Equatable {
  final SavePostInstagramStatus? status;
  final bool isSave;
  final String? message;
  const SavePostInstagramState({
    this.status,
    this.message,
    this.isSave=false,
  });

  SavePostInstagramState copyWith({
    SavePostInstagramStatus? status,
    String? message,
    bool? isSave,
  }) {
    return SavePostInstagramState(
      status: status ?? this.status,
      message: message ?? this.message,
      isSave: isSave ?? this.isSave,
    );
  }

  @override
  List<Object?> get props => [status, message];
}