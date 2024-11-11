import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/cubits/here_cubit/cubit/here_location_cubit.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/cubits/mapBox_cubit/cubit/map_box_cubit_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/cubits/starting_location/starting_location_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/views/widgets/button.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class StartHereTextField extends StatefulWidget {
  const StartHereTextField({super.key});

  @override
  State<StartHereTextField> createState() => _StartHereTextField();
}

class _StartHereTextField extends State<StartHereTextField> {
  late TextEditingController startingController;
  late final StartingLocationCubit startingLocationCubit;
  late final HereLocationCubit hereLocationCubit;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    hereLocationCubit = context.read<HereLocationCubit>();
    startingLocationCubit = context.read<StartingLocationCubit>();
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
        height: 75.h,
        margin: EdgeInsets.only(top: 10.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: BlocBuilder<HereLocationCubit, HereLocationState>(
                builder: (context, state) {
                  return TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      fillColor: Colors.transparent,
                      isDense: true,
                      contentPadding: const EdgeInsets.all(14),
                      suffixIcon:
                          _getIcon(state), // Use the icon based on the state
                      labelText: LocaleKeys.startingPoint.localize,
                    ),
                    controller: startingController,
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
                  hereLocationCubit.searchLocationHere(
                      apiKey: "", query: startingController.text);
                }
              },
              height: double.infinity,
            ),
          ],
        ),
      ),
    );
  }

  Widget? _getIcon(HereLocationState state) {
    if (state is HereLocationSuccess) {
      return const Icon(
        Icons.check,
        color: AppColors.CHECK_MARK_COLOR,
        size: 30,
      );
    }
    if (state is HereLocationLoading) {
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
    if (state is HereLocationFailure) {
      return const Icon(
        Icons.error,
        color: Colors.red,
        size: 30,
      );
    }
    if (state is HereLocationInitial) {
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

    return null;
  }
}
