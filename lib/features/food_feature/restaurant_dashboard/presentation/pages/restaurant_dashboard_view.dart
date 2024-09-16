import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../res/strings/labels.dart';
import '../../../../../res/style/styles.dart';
import '../cubit/restaurant_dashboard_cubit.dart';
import '../widgets/restaurant_order_card.dart';

class RestaurantDashboardView extends StatelessWidget {
  const RestaurantDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<RestaurantDashboardCubit>();
    return BlocConsumer<RestaurantDashboardCubit, RestaurantDashboardState>(
        listener: (context, state) {},
        builder: (context, state) {
          return SharedScaffold(
              mainCategoryId: 1,
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Label(
                          text: Labels.connected,
                          style: Styles.headerText(),
                        )),
                        if (state.connected)
                          SizedBox(
                            height: 15.h,
                            width: 15.w,
                            child: const CircularProgressIndicator.adaptive(),
                          ),
                        Switch(
                            value: state.connected,
                            onChanged: (v) async =>
                                await controller.changeConnectivityStatus())
                      ],
                    ),
                    Expanded(
                      child: !state.connected
                          ? const Center(
                              child: Label(text: 'Not Connected'),
                            )
                          : ListView.separated(
                              itemBuilder: (context, index) =>
                                  RestaurantOrderCard(
                                      item: state.orders![index]),
                              separatorBuilder: (context, index) => Sizer(),
                              itemCount: state.orders?.length ?? 0),
                    ),
                  ],
                ),
              ));
        });
  }
}
