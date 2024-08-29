import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/features/trip_join/presentation/cubits/trip_join_view/trip_join_view_cubit.dart';

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
    return DefaultTextFormField(
      currentController: TextEditingController(),
      hint: '',
      label: 'Phone Number',
      keyboardType: TextInputType.phone,
      onChanged: (value) {
        tripJoinViewCubit.phoneNumber = value;
      },
    );
  }
}
