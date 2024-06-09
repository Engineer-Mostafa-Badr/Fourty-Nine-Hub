import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../../../common/widgets/stateless/labels/label.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../../res/style/styles.dart';
import '../../../cubit/riderequest_cubit.dart';

class RideOptions extends StatelessWidget {
  const RideOptions({super.key});
  @override
  Widget build(BuildContext context) {
    final rideCubit = context.read<RiderequestCubit>();

    return BlocBuilder<RiderequestCubit, RiderequestState>(
        builder: (context, state) {
      if (state.loading) {
        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      }

      return Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15), topLeft: Radius.circular(15))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // shrinkWrap: true,
          children: [
            Row(
              children: [
                Expanded(
                    child: Label(
                        text: 'Air Conditioner',
                        style: Styles.mediumText(fontWeight: FontWeight.bold))),
                Switch(
                    value: state.isAirConditioned,
                    onChanged: (v) =>
                        rideCubit.changeAirConditionValue(value: v))
              ],
            ),
            Label(
                text: "Car Model Year",
                style: Styles.mediumText(fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final carType = state.carTypes?[index];
                  return Row(
                    children: [
                      Expanded(
                          child: Label(
                              text: carType?.brand ?? '',
                              style: Styles.mediumText())),
                      Switch(
                          value: state.selectedCarTypes?.contains(carType!) ??
                              false,
                          onChanged: (v) =>
                              rideCubit.selectCarType(item: carType!)),
                    ],
                  );
                },
                itemCount: state.carTypes?.length ?? 0,
              ),
            ),
            const Sizer(),
            AppButton(label: 'Save', onPressed: () => context.pop()),
          ],
        ),
      );
    });
  }
}
