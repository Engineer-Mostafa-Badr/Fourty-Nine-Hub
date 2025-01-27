import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/ride/Authentication/data/models/parts_socket_model.dart';
import 'package:fourtyninehub/features/ride/Authentication/presentation/cubit/authentication_ride_cubit.dart';
import 'package:fourtyninehub/features/ride/Authentication/presentation/cubit/check_part_active_cubit.dart';
import 'package:fourtyninehub/features/ride/Authentication/presentation/widgets/ride_socket_parts_widget.dart';

class RideSocketPartsScreen extends StatefulWidget {
  const RideSocketPartsScreen({super.key});

  @override
  State<RideSocketPartsScreen> createState() => _RideSocketPartsScreenState();
}

class _RideSocketPartsScreenState extends State<RideSocketPartsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<CheckPartActiveCubit>().check();
  }

  @override
  Widget build(BuildContext context) {
    context.read<CheckPartActiveCubit>().check();
    return BlocBuilder<CheckPartActiveCubit, AuthenticationRideState>(
      builder: (context, state) {
        if (state is SuccessGetPartRideSocketModelState) {
          return RideSocketPartsWidget(
            model: state.model,
          );
        } else {
          return RideSocketPartsWidget(model: PartsSocketModel());
        }
      },
    );
  }
}
