import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/chance_feature/presentation/controller/cubit/chance_cubit.dart';
import 'package:fourtyninehub/features/chance_feature/presentation/controller/cubit/chance_states.dart';

import '../../../../res/style/app_colors.dart';

class LinerProgressIndicator extends StatefulWidget {
  const LinerProgressIndicator({super.key});

  @override
  State<LinerProgressIndicator> createState() => _LinerProgressIndicatorState();
}

class _LinerProgressIndicatorState extends State<LinerProgressIndicator> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChanceCubit, ChanceState>(
      builder: (context, state) {
        return Container(
          height: 20.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: 0.2,
              color: AppColors.SECONDARY_COLOR,
              backgroundColor: Colors.grey.shade300,
            ),
          ),
        );
      },
    );
  }
}
