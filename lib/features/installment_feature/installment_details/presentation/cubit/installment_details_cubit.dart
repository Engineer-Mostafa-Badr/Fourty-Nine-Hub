import 'package:bloc/bloc.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../res/strings/labels.dart';
import '../../../installment_list/domain/entities/installment_entity.dart';
import '../../../installment_list/domain/entities/installment_plan_entity.dart';
import '../../domain/usecases/buy_installment_usecase.dart';
import '../../domain/usecases/get_installment_details_usecase.dart';

part 'installment_details_state.dart';

class InstallmentDetailsCubit extends Cubit<InstallmentDetailsState> {
  final GetInstallmentDetailsUseCase _getInstallmentDetailsUseCase;
  final BuyWithInstallmentUseCase _buyWithInstallmentUseCase;
  InstallmentDetailsCubit(
    this._buyWithInstallmentUseCase,
    this._getInstallmentDetailsUseCase,
  ) : super(const InstallmentDetailsState());

  void loadData() async {
    await getInstallmentDetails();
  }

  Future<void> getInstallmentDetails() async {
    final response = await _getInstallmentDetailsUseCase.call(0);
    response.fold(
        (l) => emit(
            state.copyWith(failure: l, status: InstallmentDetailsStates.error)),
        (data) => emit(state.copyWith(
            installment: data,
            selectedPlan: data.plans?.first,
            status: InstallmentDetailsStates.initState)));
  }

  void buyWithInstallment() async {
    final response = await _buyWithInstallmentUseCase
        .call(state.selectedPlan?.duration ?? 0);
    response.fold(
        (failure) => emit(state.copyWith(
            status: InstallmentDetailsStates.error, failure: failure)),
        (done) => emit(state.copyWith(
            status: InstallmentDetailsStates.success,
            successMessage: Labels.buyWithInstallmentSuccess)));
  }

  void changeInstallmentPlan({required InstallmentPlanEntity v}) => emit(state
      .copyWith(selectedPlan: v, status: InstallmentDetailsStates.initState));
}
