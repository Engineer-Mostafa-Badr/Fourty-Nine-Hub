import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/health_feature/doctor_login/presentation/cubit/doctor_login_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_login/presentation/widgets/fields/price_field.dart';
import 'package:fourtyninehub/features/health_feature/doctor_login/presentation/widgets/time_tables/time_table.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class DoctorLoginHomeVisitTimeTable extends StatelessWidget {
  const DoctorLoginHomeVisitTimeTable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorLoginCubit, DoctorLoginState>(
      builder: (context, state) {
        if (state.hasHomeVisit) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Home Visit', style: Styles.headerText()),
              const Sizer(),
              TimeTable(times: context.read<DoctorLoginCubit>().homeVisitTimes),
              const Sizer(),
              DoctorLoginPriceField(
                currentFocusNode:
                    context.read<DoctorLoginCubit>().homeVisitPriceFocusNode,
                currentController:
                    context.read<DoctorLoginCubit>().homeVisitPriceController,
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
