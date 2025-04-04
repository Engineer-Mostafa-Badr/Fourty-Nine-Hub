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
        height: 80.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color.fromRGBO(245, 245, 245, 1),
          borderRadius: BorderRadius.circular(15),
        ),
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
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(15)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(15)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(15)),
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(15)),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(15)),
                      fillColor: Color.fromRGBO(245, 245, 245, 1),
                      isDense: true, // Added this

                      suffixIcon: _getIcon(state),
                      prefixIcon: Container(
                        margin: EdgeInsets.symmetric(horizontal: 12.w),
                        height: 16.w,
                        width: 16.w,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(56, 151, 240, 1)),
                        child: Center(
                          child: Container(
                            height: 12.w,
                            width: 12.w,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                          ),
                        ),
                      ),
                      prefixIconConstraints: BoxConstraints(
                          maxHeight: 28,
                          maxWidth: 28,
                          minWidth: 28,
                          minHeight: 28),
                      labelText: LocaleKeys.startingPoint.localize,
                      labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 25.sp,
                          fontWeight: FontWeight.w400),
                    ),
                    cursorColor: AppColors.PRIMARY_COLOR,
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
