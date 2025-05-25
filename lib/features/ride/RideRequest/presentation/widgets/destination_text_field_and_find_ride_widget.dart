import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_destination_point_ride_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/views/widgets/button.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';

class DestinationTextFieldAndFindRideWidget extends StatefulWidget {
  const DestinationTextFieldAndFindRideWidget({super.key});

  @override
  State<DestinationTextFieldAndFindRideWidget> createState() =>
      _DestinationTextFieldAndFindRideWidgetState();
}

class _DestinationTextFieldAndFindRideWidgetState
    extends State<DestinationTextFieldAndFindRideWidget> {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController destinationPoint = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        height: 105.h,
        margin: EdgeInsets.only(top: 10.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: BlocBuilder<GetDestinationPointRideCubit, RiderState>(
                builder: (context, state) {
                  return TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      fillColor: Colors.transparent,
                      isDense: true, // Added this
                      contentPadding: const EdgeInsets.all(14),
                      suffixIcon: _getIcon(state),
                      labelText: LocaleKeys.destinationPoint.localize,
                    ),
                    controller: destinationPoint,
                    // labelStyle: const TextStyle(color: Colors.black),
                    // hint: 'Find your starting Point..!',
                    validator: _validator,
                  );
                },
              ),
            ),
            const Sizer(width: 5),
            SizedBox(
              height: 75.h,
              child: CustomButton(
                title: LocaleKeys.searchFind.localize,
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    context
                        .read<GetDestinationPointRideCubit>()
                        .getDestinationPoint(address: destinationPoint.text);
                  }
                },
                height: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget? _getIcon(RiderState state) {
    log(state.toString());
    if (state is SuccessGetDestinationPointState) {
      return const Icon(
        Icons.check,
        color: AppColors.CHECK_MARK_COLOR,
        size: 30,
      );
    }

    if (state is DestintionLocationLoading) {
      return const SizedBox(
        width: 30,
        height: 30,
        child: Center(
          child: CustomCircularProgressIndicator(
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

    return const Icon(
      Icons.error,
      color: Colors.grey,
      size: 30,
    ); // Default case
  }

  String? _validator(String? value) {
    if (value == null || value.isEmpty) {
      return LocaleKeys.youCantLeaveFieldEmpty.localize;
    }
    // if (value.length < 10) {
    //   return LocaleKeys.addressMustBeAtLeast10Chars.localize;
    // }
    return null;
  }
}
