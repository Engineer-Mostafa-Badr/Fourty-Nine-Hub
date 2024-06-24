import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/back_appbar.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/cubit/ads_cubit.dart';

import '../../../../../res/style/app_colors.dart';
import '../widgets/ad_card.dart';

class AdsView extends StatelessWidget {
  const AdsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(
        backColor: AppColors.PRIMARY_COLOR,
        iconColor: Colors.white,
        label: 'Ads',
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<AdsCubit, AdsState>(
            
              builder: (context, state) {
                return GridView.builder(
                    itemBuilder: (context, index) => AdCard(
                          item: state.ads![index],
                        ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: .8,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            crossAxisCount: 2),
                    itemCount: state.ads?.length ?? 0);
              })),
    );
  }
}
