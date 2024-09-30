import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return TextFormField(
      // currentController: TextEditingController(),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        fillColor: Colors.transparent,
        label: const Text('Phone Number'),
        isDense: true, // Added this
        contentPadding: EdgeInsets.all(14),
      ),
      keyboardType: TextInputType.phone,
      onChanged: (value) {
        tripJoinViewCubit.phoneNumber = value;
      },
      validator: (value) {
        return _validateMobile(value);
      },
    );
  }

  String? _validateMobile(String? value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }
}
