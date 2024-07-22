import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/health_feature/doctor_login/presentation/cubit/doctor_login_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_login/presentation/widgets/fields/price_field.dart';
import 'package:fourtyninehub/features/health_feature/doctor_login/presentation/widgets/fields/waiting_field.dart';
import 'package:fourtyninehub/features/health_feature/doctor_login/presentation/widgets/time_tables/time_table.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class DoctorLoginClinicTimeTable extends StatelessWidget {
  const DoctorLoginClinicTimeTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Clinic', style: Styles.headerText()),
        const Sizer(),
        TimeTable(times: context.read<DoctorLoginCubit>().clinicTimes),
        const Sizer(),
        DoctorLoginPriceField(
          currentFocusNode:
              context.read<DoctorLoginCubit>().clinicPriceFocusNode,
          currentController:
              context.read<DoctorLoginCubit>().clinicPriceController,
        ),
        const Sizer(),
        const DcoctorLoginWaitingField(),
      ],
    );
  }
}
