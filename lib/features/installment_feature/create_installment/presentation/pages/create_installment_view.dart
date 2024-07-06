import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/installment_feature/create_installment/presentation/cubit/create_installment_cubit.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../res/strings/labels.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';

class CreateInstallmentView extends StatelessWidget {
  const CreateInstallmentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BackAppBar(
          label: 'Create Installment',
        ),
        body: BlocConsumer<CreateInstallmentCubit, CreateInstallmentState>(
            builder: (context, state) {
              final controller = context.read<CreateInstallmentCubit>();
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Label(
                      text: "Plans (${state.plans?.length ?? 0})",
                      style: Styles.headerText(),
                    ),
                    Form(
                        key: controller.formKey,
                        child: Row(
                          children: [
                            Expanded(
                                child: FormTextField(
                              controller: controller.durationController,
                              type: TextInputType.number,
                              hint: 'Duration',
                            )),
                            const Sizer(),
                            Expanded(
                                child: FormTextField(
                              controller: controller.installmentController,
                              type: TextInputType.number,
                              hint: 'Installment',
                            )),
                            const Sizer(),
                            Container(
                              decoration: BoxDecoration(
                                  color: AppColors.PRIMARY_COLOR,
                                  borderRadius: BorderRadius.circular(5)),
                              child: IconButton(
                                  onPressed: () => controller.addPlan(),
                                  color: Colors.white,
                                  icon: const Icon(Icons.add)),
                            ),
                          ],
                        )),
                    Expanded(
                      child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: state.plans?.length ?? 0,
                          separatorBuilder: (context, index) => const Sizer(
                                height: 5,
                              ),
                          itemBuilder: (context, index) {
                            final item = state.plans![index];
                            return Row(
                              children: [
                                Expanded(
                                    child: Label(
                                  text: '${item.duration} Months',
                                  style: Styles.headerText(),
                                )),
                                Expanded(
                                    child: Label(
                                        text:
                                            '${item.installment} ${Labels.currency}',
                                        style: Styles.headerText())),
                                Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.SECONDARY_COLOR,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: IconButton(
                                      onPressed: () =>
                                          controller.removePlan(index: index),
                                      color: Colors.white,
                                      icon: const Icon(Icons.delete)),
                                ),
                              ],
                            );
                          }),
                    ),
                    AppButton(
                        label: 'Save Installment',
                        backColor: (state.plans?.isEmpty ?? true)
                            ? AppColors.SECONDARY_COLOR.withOpacity(.5)
                            : null,
                        onPressed: () {
                          if (state.plans?.isNotEmpty ?? false) {
                            context.push(Routes.INSTALLMENTDETAILS);
                          }
                        })
                  ],
                ),
              );
            },
            listener: (context, state) {}));
  }
}
