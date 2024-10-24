import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/cubits/destination_location_carpool/cubit/map_box_dest_cubit_cubit.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/cubits/destination_location_carpool/cubit/map_box_dest_cubit_state.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/cubits/mapBox_cubit/cubit/map_box_cubit_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/cubits/destination_location/destination_location_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/views/widgets/button.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class DestinationTextFieldAndFindButonMapBox extends StatefulWidget {
  const DestinationTextFieldAndFindButonMapBox({super.key});

  @override
  State<DestinationTextFieldAndFindButonMapBox> createState() =>
      _DestinationTextFieldAndFindButonState();
}

class _DestinationTextFieldAndFindButonState
    extends State<DestinationTextFieldAndFindButonMapBox> {
  late TextEditingController destinationController;
  late final DestinationLocationCubit destinationLocationCubit;
  late final MapBoxDestCubit mapBoxDestCubit;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    mapBoxDestCubit = context.read<MapBoxDestCubit>();

    destinationLocationCubit = context.read<DestinationLocationCubit>();
    destinationController = TextEditingController();
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
      child: Container(
        height: 75.h,
        margin: EdgeInsets.only(top: 10.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: BlocBuilder<MapBoxDestCubit, MapBoxDestCubitState>(
                builder: (context, state) {
                  return TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      fillColor: Colors.transparent,
                      isDense: true,
                      contentPadding: const EdgeInsets.all(14),
                      suffixIcon: _getIcon(state), // Icon based on state
                      labelText: LocaleKeys.destinationPoint.localize,
                    ),
                    controller: destinationController,
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
                  mapBoxDestCubit.searchLocationMapBoxDest(
                      query: destinationController.text);
                }
              },
              height: double.infinity,
            ),
          ],
        ),
      ),
    );
  }

  Widget? _getIcon(MapBoxDestCubitState state) {
    if (state is MapBoxDestCubitSuccess) {
      return const Icon(
        Icons.check,
        color: AppColors.CHECK_MARK_COLOR,
        size: 30,
      );
    }
    if (state is MapBoxDestCubitLoading) {
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
    if (state is MapBoxDestCubitFailure) {
      return const Icon(
        Icons.error,
        color: Colors.red,
        size: 30,
      );
    }
    if (state is MapBoxDestCubitInitial) {
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
