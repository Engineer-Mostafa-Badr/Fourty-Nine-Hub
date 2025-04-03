import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/cubits/trip_join_view/trip_join_view_cubit.dart';

class DriverPhoneNumberV2 extends StatefulWidget {
  const DriverPhoneNumberV2({
    super.key,
  });

  @override
  State<DriverPhoneNumberV2> createState() => _DriverPhoneNumberV2State();
}

class _DriverPhoneNumberV2State extends State<DriverPhoneNumberV2> {
  late final TextEditingController textEditingController;
  late final TripJoinViewCubit tripJoinViewCubit;

  @override
  void initState() {
    tripJoinViewCubit = context.read<TripJoinViewCubit>();
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80.h,
      child: TextFormField(
        // currentController: TextEditingController(),
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
          contentPadding: const EdgeInsets.all(14),
          labelStyle: TextStyle(
              color: Colors.black,
              fontSize: 25.sp,
              fontWeight: FontWeight.w400),
          label: Text(LocaleKeys.phoneNumber.localize),
        ),
        keyboardType: TextInputType.phone,
        onChanged: (value) {
          tripJoinViewCubit.phoneNumber = value;
        },
        validator: (value) {
          return _validateMobile(value);
        },
      ),
    );
  }

  String? _validateMobile(String? value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return LocaleKeys.youCantLeaveFieldEmpty.localize;
    } else if (!regExp.hasMatch(value)) {
      return LocaleKeys.enterValidPhoneNumber.localize;
    }
    return null;
  }
}
