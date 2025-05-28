import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_driver_ride_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/update_driver_socket_form.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';

class UpdateDriverRideScreen extends StatelessWidget {
  const UpdateDriverRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      mainCategoryId: 1,
      body: BlocBuilder<GetDriverRideCubit, RiderState>(
        builder: (context, state) {
          if (state is LoadingRiderState) {
            return const Center(
              child: CustomCircularProgressIndicator(
                color: AppColors.PRIMARY_COLOR,
              ),
            );
          }
          if (state is SuccessGetDriverRideState) {
            return UpdateDriverSocketForm(
              model: state.model,
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
