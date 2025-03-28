import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../core/enums/base_status_enum.dart';
import '../../../../../core/error/failure.dart';
import '../../../installment_list/data/models/installment_plan_model.dart';
import '../../domain/usecases/create_installment_usecase.dart';

part 'create_installment_state.dart';

class CreateInstallmentCubit extends Cubit<CreateInstallmentState> {
  final durationController = TextEditingController();
  final installmentController = TextEditingController();
  final downPaymentController = TextEditingController();
  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final CreateInstallmentUseCase _createInstallmentUseCase;
  CreateInstallmentCubit(this._createInstallmentUseCase)
      : super(const CreateInstallmentState());

  void addPlan({required String adId}) {
    if (formKey.currentState?.validate() ?? false) {
      List<InstallmentPlanModel> plans = state.plans ?? [];
      plans.add(InstallmentPlanModel(
        adId: adId,
        duration: num.tryParse(durationController.text) ?? 0,
        installment: num.tryParse(installmentController.text) ?? 0,
        startPrice: num.tryParse(downPaymentController.text) ?? 0,
        name: nameController.text,
      ));
      emit(state.copyWith(plans: plans));
    }
  }

  void saveInstallment() async {
    // bool success = true;
    Failure? failure;
    for (var item in state.plans ?? []) {
      final response = await _createInstallmentUseCase(item);
      response.fold((l) {
        failure = l;
      }, (r) {});
    }
    if (failure == null) {
      emit(state.copyWith(
        status: StateStatus.success,
      ));
    } else {
      emit(state.copyWith(
        status: StateStatus.error,
        failure: failure,
      ));
    }
  }

  void removePlan({required int index}) {
    List<InstallmentPlanModel> plans = state.plans ?? [];
    plans.removeAt(index);

    emit(state.copyWith(plans: plans));
  }
}
