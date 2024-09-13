import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/cubits/starting_location/starting_location_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/views/widgets/button.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class StartTextFieldAndFindButon extends StatefulWidget {
  const StartTextFieldAndFindButon({
    super.key,
  });

  @override
  State<StartTextFieldAndFindButon> createState() =>
      _StartTextFieldAndFindButonState();
}

class _StartTextFieldAndFindButonState
    extends State<StartTextFieldAndFindButon> {
  late TextEditingController startingController;
  late final StartingLocationCubit startingLocationCubit;
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    startingLocationCubit = context.read<StartingLocationCubit>();
    startingController = TextEditingController();
    super.initState();
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
      child: SizedBox(
        // height: 45.h,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: BlocBuilder<StartingLocationCubit, StartingLocationState>(
                builder: (context, state) {
                  return DefaultTextFormField(
                    suffixIcon: _getIcon(state),
                    currentController: startingController,
                    label: 'Starting Point',
                    // hint: 'Find your starting Point..!',
                    hint: '',
                    validator: _validator,
                  );
                },
              ),
            ),
            Sizer(width: 5),
            CustomButton(
              onTap: () {
                if (formKey.currentState!.validate()) {
                  startingLocationCubit.getStartingLocation(
                      address: startingController.text);
                }
              },
              height: 45.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget? _getIcon(StartingLocationState state) {
    if (state is StartingLocationSuccess) {
      return const Icon(
        Icons.check,
        color: AppColors.CHECK_MARK_COLOR,
        size: 30,
      );
    }
    if (state is StartingLocationLoading) {
      return SizedBox(
        width: 10,
        height: 10.h,
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.PRIMARY_COLOR,
            strokeWidth: 3,
          ),
        ),
      );
    }
    if (state is StartingLocationFailed) {
      return const Icon(
        Icons.error,
        color: Colors.red,
        size: 30,
      );
    }
    if (state is StartingLocationInitial) {
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
