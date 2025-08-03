import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../cubits/trip_join_view/trip_join_view_cubit.dart';

import '../../../../../../common/widgets/form/text_fields/new_phone_number_text_field.dart';

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
      child: NewPhoneNumberTextFormField(
        currentController: TextEditingController(),
        onChanged: (value) {
          tripJoinViewCubit.phoneNumber = value;
        },
        isRequired: true,
      ),
    );
  }
}
