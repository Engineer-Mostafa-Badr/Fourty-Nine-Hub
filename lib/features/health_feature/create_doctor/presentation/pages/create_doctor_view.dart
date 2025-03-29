import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/create_doctor_view_body.dart';
import '../../../../../core/widget/custom_scaffold.dart';

class CreateDoctorView extends StatelessWidget {
  const CreateDoctorView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateDoctorCubit, CreateDoctorState>(
      listener: (context, state) {
        switch (state) {
          case CreateDoctorLoading _:
            showLoadingDialog(context);
            break;
          case CreateDoctorCloseLoading _:
            Navigator.pop(context);
            break;
          case CreateDoctorError _:
            showErrorMessage(context, state.message);
            break;
          case CreateDoctorSuccess _:
            showSuccessMessage(context, state.message);
            break;
          default:
            break;
        }
      },
      child: const CustomScaffold(
        appBar: HomeAppbar(),
        body: CreateDoctorViewBody(),
      ),
    );
  }
}
