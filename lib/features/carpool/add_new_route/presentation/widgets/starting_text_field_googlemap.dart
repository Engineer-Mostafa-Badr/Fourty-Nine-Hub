import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/cubits/get_llat_and_long/cubit/get_lat_and_long_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/views/widgets/button.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class StartTextFieldAndFindButonGoogleMap extends StatefulWidget {
  const StartTextFieldAndFindButonGoogleMap(
      {super.key, this.isTripJoin = false});
  final bool isTripJoin;

  @override
  State<StartTextFieldAndFindButonGoogleMap> createState() =>
      _StartTextFieldAndFindButonState();
}

class _StartTextFieldAndFindButonState
    extends State<StartTextFieldAndFindButonGoogleMap> {
  late TextEditingController startingController;
  // late final StartingLocationCubit startingLocationCubit;
  late final GetLatAndLongCubit getLatAndLongCubit;
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    getLatAndLongCubit = context.read<GetLatAndLongCubit>();
    startingController = TextEditingController();
  }

  @override
  void dispose() {
    startingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        height: 100.h,
        margin: EdgeInsets.only(top: 10.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: BlocBuilder<GetLatAndLongCubit, GetLatAndLongState>(
                builder: (context, state) {
                  return TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      fillColor: Colors.transparent,
                      isDense: true, // Added this
                      contentPadding: const EdgeInsets.all(14),
                      suffixIcon: _getIcon(state),
                      labelText: LocaleKeys.startingPoint.localize,
                    ),
                    controller: startingController,
                    // labelStyle: const TextStyle(color: Colors.black),
                    // hint: 'Find your starting Point..!',
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
                  getLatAndLongCubit.getLatAndLong(
                      context: context,
                      isStart: true,
                      isTripJoin: widget.isTripJoin,
                      address: startingController.text);
                }
              },
              height: double.infinity,
            ),
          ],
        ),
      ),
    );
  }

  Widget? _getIcon(GetLatAndLongState state) {
    if (state is GetLatAndLongSuccess) {
      return const Icon(
        Icons.check,
        color: AppColors.CHECK_MARK_COLOR,
        size: 30,
      );
    }
    if (state is GetLatAndLongLoading) {
      return const SizedBox(
        width: 30,
        height: 30,
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.PRIMARY_COLOR,
            strokeWidth: 3,
          ),
        ),
      );
    }
    if (state is GetLatAndLongFailure) {
      return const Icon(
        Icons.error,
        color: Colors.red,
        size: 30,
      );
    }
    if (state is GetLatAndLongInitial) {
      return const Icon(
        Icons.error,
        color: Colors.grey,
        size: 30,
      );
    }
    return null; // Default case
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
