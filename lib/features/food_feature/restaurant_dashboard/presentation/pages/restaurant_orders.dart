import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/presentation/cubit/restaurant_dashboard_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/presentation/widgets/restaurant_order_card.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class RestaurantDashboardOrders extends StatefulWidget {
  const RestaurantDashboardOrders({super.key});

  @override
  State<RestaurantDashboardOrders> createState() => _RestaurantDashboardOrdersState();
}

class _RestaurantDashboardOrdersState extends State<RestaurantDashboardOrders> {
  late ScrollController _scrollController;
  bool isFirstSearchListenerCall = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    context.read<RestaurantDashboardCubit>().loadData();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent -200) {
      context.read<RestaurantDashboardCubit>().getOrders();
    }
  }
  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Restaurant Orders',
          style: Styles.headerText(),),
      ),
      body: BlocBuilder<RestaurantDashboardCubit,RestaurantDashboardState>(
        builder: (context,state) {
          var controller = context.read<RestaurantDashboardCubit>();
          return state.isLoading?const Center(child: CircularProgressIndicator(),):ListView(
            padding: EdgeInsets.all(16.w),
            controller: _scrollController,
            shrinkWrap: true,
            children: [
              if (controller.orders[0].openCallAndChat !=
                  'enable')
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        LocaleKeys.subscribeToContactTheClient.localize,
                        style: Styles.headerText(
                            color: AppColors.PRIMARY_COLOR_DARK),
                      ),
                    ),
                    ClickableWidget(
                      onTap: (){
                        // SubscriptionMethod().subscribe(subscribeId: , title: LocaleKeys.restaurantDashboard.localize);

                      },
                      child: Text(
                        LocaleKeys.subscribe.localize,
                        style: Styles.headerText(
                            color: AppColors.PRIMARY_COLOR,decorationThickness: 2.w,decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                )
              else
                const Sizer(),
              ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                      final order = controller.orders[index];
                      return Column(
                        children: [
                          RestaurantOrderCard(item: order),

                        ],
                      );

                  },
                  separatorBuilder: (context, index) => const Sizer(
                    height: 20,
                  ),
                  itemCount: controller.orders.length ),
              if(controller.isLoadingMore==true)const Center(child: CircularProgressIndicator(),),
            ],
          );
        }
      ),
    );
  }
}
