import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/loading/custom_loading.dart';
import 'package:fourtyninehub/features/chance_feature/presentation/controller/cubit/chance_cubit.dart';
import 'package:fourtyninehub/features/chance_feature/presentation/controller/cubit/chance_states.dart';
import 'package:fourtyninehub/features/chance_feature/presentation/widgets/chance_card_widget.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

import '../../../../res/style/app_colors.dart';

class ListViewCard extends StatelessWidget {
  const ListViewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChanceCubit>(
      create: (BuildContext context) => serviceLocator()..fetchChance(),
      child: BlocBuilder<ChanceCubit, ChanceState>(
        builder: (BuildContext context, state) {
          if (state.status == ChanceStates.success) {
            if (state.chance == null || state.chance!.isEmpty) {
              return const Center(child: Text('No data available.'));
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => ChanceCardWidget(
                chance: state.chance![index],
                index: index,
              ),
              separatorBuilder: (context, index) => Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: const Divider(
                  height: 1,
                  color: AppColors.GREY_NORMAL_COLOR,
                ),
              ),
              itemCount: state.chance?.length ?? 0,
            );
          } else if (state.status == ChanceStates.loading) {
            return const CustomLoading();
          } else if (state.status == ChanceStates.error) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Problem'),
                    content: Text(' ${state.failure.toString()}'),
                    actions: [
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            });
            return const SizedBox();
          } else {
            return const CustomLoading();
          }
        },
      ),
    );
  }
}
