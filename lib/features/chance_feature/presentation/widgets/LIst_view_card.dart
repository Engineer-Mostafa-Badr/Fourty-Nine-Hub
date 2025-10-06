import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/loading/custom_loading.dart';
import 'package:fourtyninehub/features/chance_feature/presentation/controller/cubit/chance_cubit.dart';
import 'package:fourtyninehub/features/chance_feature/presentation/controller/cubit/chance_states.dart';
import 'package:fourtyninehub/features/chance_feature/presentation/widgets/chance_card_widget.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

import '../../../../helpers/manage_vibration.dart';
import '../../../../res/style/app_colors.dart';

class ListViewCard extends StatelessWidget {
  const ListViewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChanceCubit>(
      create: (BuildContext context) => serviceLocator()..getAllChanceAds(),
      child: BlocBuilder<ChanceCubit, ChanceState>(
        builder: (BuildContext context, state) {
          if (state.status == ChanceStates.success) {
            // Determine which data to show (search results or all chance ads)
            final dataToShow = state.searchResults ?? state.chanceAds;

            if (dataToShow == null || dataToShow.isEmpty) {
              return Center(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Icon(
                      state.searchResults != null
                          ? Icons.search_off
                          : Icons.inventory_2_outlined,
                      size: 64,
                      color: AppColors.GREY_NORMAL_COLOR,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.searchResults != null
                          ? 'No results found'
                          : 'No chance ads available.',
                      style: const TextStyle(
                        color: AppColors.GREY_NORMAL_COLOR,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => ChanceCardWidget(
                chanceAd: dataToShow[index],
              ),
              separatorBuilder: (context, index) => Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: const Divider(
                  height: 1,
                  color: AppColors.GREY_NORMAL_COLOR,
                ),
              ),
              itemCount: dataToShow.length,
            );
          } else if (state.status == ChanceStates.loading) {
            return const CustomLoading();
          } else if (state.status == ChanceStates.error) {
            return Center(
              child: Column(
                children: [
                  const Text('Error loading chance ads'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ManageVibration.vibrate();
                      context.read<ChanceCubit>().getAllChanceAds();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else {
            return const CustomLoading();
          }
        },
      ),
    );
  }
}
