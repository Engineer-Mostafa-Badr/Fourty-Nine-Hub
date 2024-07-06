import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../installment_list/domain/entities/installment_plan_entity.dart';

part 'create_installment_state.dart';

class CreateInstallmentCubit extends Cubit<CreateInstallmentState> {
  final durationController = TextEditingController();
  final installmentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  CreateInstallmentCubit() : super(const CreateInstallmentState());

  void addPlan() {
    if (formKey.currentState?.validate() ?? false) {
      List<InstallmentPlanEntity> plans = state.plans ?? [];
      plans.add(InstallmentPlanEntity(
        duration: num.tryParse(durationController.text) ?? 0,
        installment: num.tryParse(installmentController.text) ?? 0,
      ));
      emit(state.copyWith(plans: plans));
    }
  }

  void removePlan({
    required int index
  }) {
    List<InstallmentPlanEntity> plans = state.plans ?? [];
      plans.removeAt(index);
      
      emit(state.copyWith(plans: plans));
   
  }
}
