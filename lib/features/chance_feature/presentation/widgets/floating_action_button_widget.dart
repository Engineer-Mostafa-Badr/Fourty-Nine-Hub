import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../pages/create_chance_view.dart';
import '../controller/cubit/chance_cubit.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import '../../../../service_locator/service_locator.dart';

class FloatingActionButtonWidget extends StatelessWidget {
  const FloatingActionButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        ManageVibration.vibrate();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider<ChanceCubit>(
              create: (context) => serviceLocator<ChanceCubit>(),
              child: const CreateChanceView(),
            ),
          ),
        );
      },
      backgroundColor: Colors.red,
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }
}
