part of 'create_installment_cubit.dart';

class CreateInstallmentState {
  final List<InstallmentPlanModel>? plans;
  final StateStatus status;
  final Failure? failure;
  const CreateInstallmentState({
    this.plans,
    this.failure,
    this.status = StateStatus.initial,
  });
  CreateInstallmentState copyWith({
    List<InstallmentPlanModel>? plans,
    Failure? failure,
    StateStatus? status,
  }) {
    return CreateInstallmentState(
        status: status ?? this.status,
        failure: failure ?? this.failure,
        plans: plans ?? this.plans);
  }
}

extension CreateInstallmentStateX on CreateInstallmentState {
  bool get isLoading => StateStatus.loading == status;
  bool get isError => StateStatus.error == status;
  bool get isSuccess => StateStatus.success == status;
  bool get isInit => StateStatus.initial == status;
}
