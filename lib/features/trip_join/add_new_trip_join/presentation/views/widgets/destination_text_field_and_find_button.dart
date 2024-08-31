import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
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
        // height: 45,
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
                    // hint: 'Find your destination point..!',
                    label: 'Destination Point',
                    hint: '',
                    validator: _validator,
                  );
                },
              ),
            ),
            const Sizer(width: 5),
            CustomButton(
              onTap: () {
                if (formKey.currentState!.validate()) {
                  destinationLocationCubit.getDestinationLocation(
                      address: destinationController.text);
                }
              },
              height: 45,
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
      return const SizedBox(
        width: 10,
        height: 10,
        child: Center(
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
      return "You can't leave the field empty";
    }
    if (value.length < 10) {
      return "Address must be at least 10 characters";
    }
    return null;
  }
}
