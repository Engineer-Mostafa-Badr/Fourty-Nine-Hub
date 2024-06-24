part of 'installment_details_cubit.dart';

enum InstallmentDetailsStates { loading, initState, error, success }

extension AuctionDetailsStateX on InstallmentDetailsState {
  bool get isLoading => status == InstallmentDetailsStates.loading;
  bool get isInitState => status == InstallmentDetailsStates.initState;
  bool get isError => status == InstallmentDetailsStates.error;
  bool get isSuccess => status == InstallmentDetailsStates.success;
}

class InstallmentDetailsState {
  final InstallmentDetailsStates status;
  final Failure? failure;
  final InstallmentEntity? installment;
  final String? successMessage;
  final InstallmentPlanEntity? selectedPlan;
  const InstallmentDetailsState(
      {this.installment,
      this.failure,
      this.successMessage,
      this.selectedPlan,
      this.status = InstallmentDetailsStates.loading});
  InstallmentDetailsState copyWith({
    InstallmentDetailsStates? status,
    Failure? failure,
    InstallmentEntity? installment,
    String? successMessage,
    InstallmentPlanEntity? selectedPlan,
  }) {
    return InstallmentDetailsState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      selectedPlan: selectedPlan?? this.selectedPlan,
      installment: installment ?? this.installment,
      successMessage: successMessage ?? this.successMessage,
    );
  }
}
