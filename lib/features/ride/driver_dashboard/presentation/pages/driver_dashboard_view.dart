import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/features/ride/driver_dashboard/presentation/cubit/driver_dashboard_cubit.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../res/style/app_colors.dart';
import '../widgets/driver_trip_card.dart';

class DriverDashboardView extends StatelessWidget {
  const DriverDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverDashboardCubit, DriverDashboardState>(
        builder: (context, state) {
      return SharedScaffold(
          mainCategoryId: 1,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // if (state.statistics != null)
                //   OrderStatisticsWidget(
                //     item: state.statistics!,
                //   ),
                // _buildConectedStatus(context: context),
                // const Sizer(),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.trips?.length ?? 0,
                    itemBuilder: (context, index) =>
                        DriverTripCard(trip: state.trips![index]),
                  ),
                ),
              ],
            ),
          ));
    });
  }

  Widget _buildConectedStatus({
    required BuildContext context,
  }) {
    final controller = context.read<DriverDashboardCubit>();

    return BlocBuilder<DriverDashboardCubit, DriverDashboardState>(
        builder: (context, state) {
      return Row(
        children: [
          Expanded(
            child: AppButton(
                onPressed: () => controller.changeConnectState(v: false),
                icon: Icons.wifi_off,
                backColor: state.connected ?? false
                    ? AppColors.SECONDARY_COLOR
                    : AppColors.SECONDARY_COLOR.withOpacity(.4),
                label: 'Not Connected'),
          ),
          const Sizer(),
          Expanded(
            child: AppButton(
                onPressed: () => controller.changeConnectState(v: true),
                backColor: state.connected ?? false
                    ? AppColors.SECONDARY_COLOR
                    : AppColors.SECONDARY_COLOR.withOpacity(.4),
                icon: Icons.wifi_outlined,
                label: 'Connected ${state.connected}'),
          ),
        ],
      );
    });
  }
}
