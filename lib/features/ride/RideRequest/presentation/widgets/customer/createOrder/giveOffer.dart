import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/riderequest_cubit.dart';
import '../../../../../../../common/widgets/form/text_fields/form_text_field.dart';
import '../../../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../../res/style/styles.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../../res/style/app_colors.dart';

class GiveOffer extends StatelessWidget {
  final formState = GlobalKey<FormState>();

  GiveOffer({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = context.read<RiderequestCubit>();
    return BlocBuilder<RiderequestCubit, RiderequestState>(
        builder: (context, state) {
      return Form(
        key: formState,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15), topLeft: Radius.circular(15))),
          child: ListView(
            shrinkWrap: true,
            children: [
              Label(
                  text: 'Offer your fare',
                  style: Styles.mediumText(fontWeight: FontWeight.bold)),
              const Sizer(),
              FormTextField(
                  hint: 'EGP',
                  type: TextInputType.number,
                  initialValue: state.offerPrice.toString(),
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold),
                  action: (v) => controller.changeExpectedPrice(v)),
              const Sizer(),
              Row(
                children: [
                  const Icon(
                    Icons.money,
                    color: Colors.green,
                  ),
                  const Sizer(),
                  Label(text: 'Cash', style: Styles.mediumText())
                ],
              ),
              const Sizer(),
              Row(
                children: [
                  const Icon(
                    Icons.rocket_launch,
                    color: AppColors.PRIMARY_COLOR,
                  ),
                  const Sizer(),
                  Expanded(
                      child: Label(
                          text:
                              'Automatically accept the nearest driver for your fare',
                          style: Styles.mediumText())),
                  Switch(
                      value: state.autoAccept,
                      onChanged: (v) => controller.changeAutoAcceptStatus(v: v))
                ],
              ),
              const Sizer(),
              AppButton(
                  label: 'Done',
                  onPressed: () {
                    if (formState.currentState!.validate()) {
                      context.pop();
                    }
                  }),
            ],
          ),
        ),
      );
    });
  }
}
