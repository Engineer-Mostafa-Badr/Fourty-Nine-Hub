import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/riderequest_cubit.dart';
import '../../../../../../../common/widgets/form/text_fields/form_text_field.dart';
import '../../../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../../res/style/styles.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../common/widgets/dynamic/sizer.dart';

class RideContactPhoneNumber extends StatelessWidget {
  final formState = GlobalKey<FormState>();
  final Function(String) onChanged;
  final Function? onSubmit;
  RideContactPhoneNumber({super.key, required this.onChanged, this.onSubmit});
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
                  text: 'Contact Phone',
                  style: Styles.mediumText(fontWeight: FontWeight.bold)),
              const Sizer(),
              FormTextField(
                  hint: 'Phone',
                  type: TextInputType.number,
                  initialValue: state.phone ?? '',
                  style: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold),
                  action: (v) => onChanged(v)),
              const Sizer(),
              AppButton(
                  label: 'Done',
                  onPressed: () {
                    if (formState.currentState!.validate()) {
                      if (onSubmit != null) {
                        onSubmit!();
                      }
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
