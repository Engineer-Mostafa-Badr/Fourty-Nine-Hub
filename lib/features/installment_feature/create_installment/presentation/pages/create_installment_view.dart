import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/installment_feature/create_installment/presentation/cubit/create_installment_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../res/strings/labels.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';

class CreateInstallmentView extends StatelessWidget {
  final String adId;
  const CreateInstallmentView({super.key, required this.adId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const BackAppBar(
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
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: FormTextField(
                              controller: controller.nameController,
                              hint: 'Name',
                            )),
                            const Sizer(),
                            Expanded(
                                child: FormTextField(
                              controller: controller.durationController,
                              type: TextInputType.number,
                              hint: 'Duration (Months)',
                            )),
                          ],
                        ),
                        const Sizer(),
                        Row(
                          children: [
                            Expanded(
                                child: FormTextField(
                              controller: controller.downPaymentController,
                              type: TextInputType.number,
                              hint: 'Down Payment',
                            )),
                            const Sizer(),
                            Expanded(
                                child: FormTextField(
                              controller: controller.installmentController,
                              type: TextInputType.number,
                              hint: 'Installment',
                            )),
                          ],
                        ),
                        const Sizer(),
                        AppButton(
                            label: Labels.addPlan,
                            onPressed: () => controller.addPlan(adId: adId))
                      ],
                    )),
                const Sizer(),
                Expanded(
                  child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: state.plans?.length ?? 0,
                      separatorBuilder: (context, index) => Sizer(
                            height: 5.h,
                          ),
                      itemBuilder: (context, index) {
                        final item = state.plans![index];
                        return Row(
                          children: [
                            Expanded(
                                child: Label(
                              text:
                                  '${item.name}: ${item.startPrice} downpayment and ${item.installment} for ${item.duration} Months',
                              style: Styles.mediumText(),
                            )),
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
                        controller.saveInstallment();
                      }
                    })
              ],
            ),
          );
        }, listener: (context, state) {
          if (state.isError && state.failure != null) {
            showErrorMessage(
              context,
              getFailureMessage(
                state.failure!,
                context,
              ),
            );
          } else if (state.isSuccess) {
            context.go(Routes.MYADDS);
            showSuccessMessage(context, Labels.success);
          }
        }));
  }
}
