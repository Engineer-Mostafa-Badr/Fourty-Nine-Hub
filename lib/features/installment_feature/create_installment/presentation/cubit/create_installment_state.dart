part of 'create_installment_cubit.dart';

class CreateInstallmentState {
  final List<InstallmentPlanEntity>? plans;
  const CreateInstallmentState({
    this.plans,
  });
  CreateInstallmentState copyWith({
    List<InstallmentPlanEntity>? plans,
  }) {
    return CreateInstallmentState(
      plans: plans??this.plans
    );
  }
}
