import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/health_feature/doctor_login/presentation/cubit/doctor_login_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_login/presentation/widgets/price_field.dart';
import 'package:fourtyninehub/features/health_feature/doctor_login/presentation/widgets/time_table.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class DoctorLoginCallTimeTable extends StatelessWidget {
  const DoctorLoginCallTimeTable({super.key});

  @override
  Widget build(BuildContext context) {
    final doctorLoginCubit = context.read<DoctorLoginCubit>();
    return BlocBuilder<DoctorLoginCubit, DoctorLoginState>(
      builder: (context, state) {
        if (state.hasCall) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Call', style: Styles.headerText()),
              const Sizer(),
              TimeTable(times: context.read<DoctorLoginCubit>().callTimes),
              const Sizer(),
              DoctorLoginPriceField(
                  currentFocusNode: doctorLoginCubit.callPriceFocusNode,
                  currentController: doctorLoginCubit.callPriceController),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
