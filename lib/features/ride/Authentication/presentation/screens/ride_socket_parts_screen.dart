import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/Authentication/data/models/parts_socket_model.dart';
import 'package:fourtyninehub/features/ride/Authentication/presentation/cubit/authentication_ride_cubit.dart';
import 'package:fourtyninehub/features/ride/Authentication/presentation/cubit/check_part_active_cubit.dart';
import 'package:fourtyninehub/features/ride/Authentication/presentation/widgets/ride_socket_parts_widget.dart';

class RideSocketPartsScreen extends StatelessWidget {
  const RideSocketPartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckPartActiveCubit, AuthenticationRideState>(
      builder: (context, state) {
        if (state is SuccessGetPartRideSocketModelState) {
          return RideSocketPartsWidget(model: state.model,);
        }
        else{
          return RideSocketPartsWidget(model: PartsSocketModel());
        }
      },
    );
  }
}
