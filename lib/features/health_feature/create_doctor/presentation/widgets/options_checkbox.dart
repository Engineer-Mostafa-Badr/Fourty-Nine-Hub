import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/check_box_item.dart';

class CreateDoctorOptionsCheckbox extends StatefulWidget {
  const CreateDoctorOptionsCheckbox({super.key});

  @override
  State<CreateDoctorOptionsCheckbox> createState() =>
      _CreateDoctorOptionsCheckboxState();
}

class _CreateDoctorOptionsCheckboxState
    extends State<CreateDoctorOptionsCheckbox> {
  bool _clinic = false;

  bool _call = false;

  bool _homeVisit = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BlocBuilder<CreateDoctorCubit, CreateDoctorState>(
          buildWhen: (previous, current) =>
              current is CreateDoctorShowClinic ||
              current is CreateDoctorInitial,
          builder: (context, state) {
            return CheckBoxItem(
              value: _clinic,
              onChanged: (value) {
                _clinic = value!;
                context.read<CreateDoctorCubit>().toggleClinic(value);
              },
              title: LocaleKeys.clinicVisit.tr(),
            );
            // return Checkbox(
            //   value: _clinic,
            //   onChanged: (value) {
            //     _clinic = value!;
            //     context.read<CreateDoctorCubit>().toggleClinic(value);
            //   },
            // );
          },
        ),
        // Text(
        //   LocaleKeys.clinicVisit.tr(),
        //   style: Styles.mediumText(),
        // ),
        // const Sizer(),
        BlocBuilder<CreateDoctorCubit, CreateDoctorState>(
          buildWhen: (previous, current) =>
              current is CreateDoctorShowCall || current is CreateDoctorInitial,
          builder: (context, state) {
            return CheckBoxItem(
              value: _call,
              onChanged: (value) {
                _call = value!;
                context.read<CreateDoctorCubit>().toggleCallCheck(value);
              },
              title: LocaleKeys.call.tr(),
            );
            // return Checkbox(
            //   value: _call,
            //   onChanged: (value) {
            //     _call = value!;
            //     context.read<CreateDoctorCubit>().toggleCallCheck(value);
            //   },
            // );
          },
        ),
        // Text(
        //   LocaleKeys.call.tr(),
        //   style: Styles.mediumText(),
        // ),
        // const Sizer(),
        BlocBuilder<CreateDoctorCubit, CreateDoctorState>(
          buildWhen: (previous, current) =>
              current is CreateDoctorShowHomeVisit ||
              current is CreateDoctorInitial,
          builder: (context, state) {
            return CheckBoxItem(
              value: _homeVisit,
              onChanged: (value) {
                _homeVisit = value!;
                context.read<CreateDoctorCubit>().toggleHomeVisit(value);
              },
              title: LocaleKeys.homeVisit.tr(),
            );
            // return Checkbox(
            //   value: _homeVisit,
            //   onChanged: (value) {
            //     _homeVisit = value!;
            //     context.read<CreateDoctorCubit>().toggleHomeVisit(value);
            //   },
            // );
          },
        ),
        // Text(
        //   LocaleKeys.homeVisit.tr(),
        //   style: Styles.mediumText(),
        // ),
      ],
    );
  }
}
