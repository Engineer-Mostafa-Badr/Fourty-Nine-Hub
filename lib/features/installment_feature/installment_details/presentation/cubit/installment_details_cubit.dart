import 'package:bloc/bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';

import '../../../../../res/strings/labels.dart';
import '../../../installment_list/domain/entities/installment_entity.dart';
import '../../../installment_list/domain/entities/installment_plan_entity.dart';
import '../../data/models/installment_request_model.dart';
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

  void buyWithInstallment({required String installmentId}) async {
    final response = await _buyWithInstallmentUseCase(InstallmentRequestModel(
      duration: state.selectedPlan?.duration ?? 0,
      downPayment: state.selectedPlan?.startPrice ?? 0,
      installmentId: installmentId,
      installment: state.selectedPlan?.installment ?? 0,
    ));
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(
          status: InstallmentDetailsStates.error, failure: failure));
    },
        (done) => emit(state.copyWith(
            status: InstallmentDetailsStates.success,
            successMessage: Labels.buyWithInstallmentSuccess)));
  }

  void changeInstallmentPlan({required InstallmentPlanEntity v}) => emit(state
      .copyWith(selectedPlan: v, status: InstallmentDetailsStates.initState));

  Future<void> getInstallmentDetails({required String installmentId}) async {
    final response = await _getInstallmentDetailsUseCase(installmentId);
    response.fold(
      (l) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(currentContext, getFailureMessage(l, currentContext));
        emit(
            state.copyWith(failure: l, status: InstallmentDetailsStates.error));
      },
      (data) => emit(state.copyWith(
          installment: data,
          // selectedPlan: data.plans?.first,
          status: InstallmentDetailsStates.initState)),
    );
  }

  void loadData({required String installmentId}) async {
    await getInstallmentDetails(installmentId: installmentId);
  }
}
