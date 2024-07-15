import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/features/ride/driver_dashboard/domain/usecases/create_rider_offer_usecase.dart';
import 'package:fourtyninehub/features/ride/driver_dashboard/presentation/cubit/driver_dashboard_cubit.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../res/strings/labels.dart';
import '../../../../../res/style/app_colors.dart';
import '../widgets/driver_trip_card.dart';

class DriverDashboardView extends StatelessWidget {
  const DriverDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DriverDashboardCubit, DriverDashboardState>(
       listener: (context, state){
        if (state.isError && state.failure!=null) {
          showErrorMessage(
            context,
            getFailureMessage(
              state.failure!,
              context,
            ),
          );
        } else if (state.isSuccess) {
          
          showSuccessMessage(context, Labels.success);
        } 
       },
        builder: (context, state) {
      final controller = context.read<DriverDashboardCubit>();
      return SharedScaffold(
          mainCategoryId: 1,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: RefreshIndicator(
              onRefresh: () async => controller.loadData(),
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
                      itemBuilder: (context, index) => DriverTripCard(
                        trip: state.trips![index],
                        acceptRide: (String id) =>
                            controller.acceptRide(id: id),
                        createOffer: (CreateRiderOfferParams params) =>
                            controller.createOffer(params: params),
                      ),
                    ),
                  ),
                ],
              ),
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
