import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/cubits/destination_location/destination_location_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/views/widgets/button.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class DestinationTextFieldAndFindButon extends StatefulWidget {
  const DestinationTextFieldAndFindButon({
    super.key,
  });

  @override
  State<DestinationTextFieldAndFindButon> createState() =>
      _DestinationTextFieldAndFindButonState();
}

class _DestinationTextFieldAndFindButonState
    extends State<DestinationTextFieldAndFindButon> {
  late TextEditingController destinationController;
  late final DestinationLocationCubit destinationLocationCubit;
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    destinationLocationCubit = context.read<DestinationLocationCubit>();
    destinationController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SizedBox(
        height: 80.h,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: BlocBuilder<DestinationLocationCubit,
                  DestinationLocationState>(
                builder: (context, state) {
                  return DefaultTextFormField(
                    suffixIcon: _getIcon(state),
                    currentController: destinationController,
                    labelStyle: const TextStyle(color: Colors.black),
                    // hint: 'Find your destination point..!',
                    label: LocaleKeys.destinationPoint.localize,
                    hint: '',
                    validator: _validator,
                  );
                },
              ),
            ),
            const Sizer(width: 5),
            CustomButton(
              title: LocaleKeys.searchFind.localize,
              onTap: () {
                if (formKey.currentState!.validate()) {
                  destinationLocationCubit.getDestinationLocation(
                      address: destinationController.text);
                }
              },
              height: double.infinity,
            ),
          ],
        ),
      ),
    );
  }

  Widget? _getIcon(DestinationLocationState state) {
    if (state is DestinationLocationSuccess) {
      return const Icon(
        Icons.check,
        color: AppColors.CHECK_MARK_COLOR,
        size: 30,
      );
    }
    if (state is DestinationLocationLoading) {
      return SizedBox(
        width: 10,
        height: 10.h,
        child: const Center(
          child: CircularProgressIndicator(
            color: AppColors.PRIMARY_COLOR,
            strokeWidth: 3,
          ),
        ),
      );
    }
    if (state is DestinationLocationFailed) {
      return const Icon(
        Icons.error,
        color: Colors.red,
        size: 30,
      );
    }
    if (state is DestinationLocationInitial) {
      return const Icon(
        Icons.error,
        color: Colors.grey,
        size: 30,
      );
    }
    return null;
  }

  String? _validator(String? value) {
    if (value == null) {
      return LocaleKeys.youCantLeaveFieldEmpty.localize;
    }
    if (value.length < 10) {
      return LocaleKeys.addressMustBeAtLeast10Chars.localize;
    }
    return null;
  }
}
