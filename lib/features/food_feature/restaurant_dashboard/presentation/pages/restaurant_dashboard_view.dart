import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/cubit/create_resturant_cubit.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/views/create_resturant_view.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/presentation/pages/cart_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/presentation/widgets/restaurant_statistics_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/widgets/subcatigories_restaurant_card.dart';
import 'package:fourtyninehub/helpers/subscription_method.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../service_locator/service_locator.dart';
import '../cubit/restaurant_dashboard_cubit.dart';
import '../widgets/restaurant_order_card.dart';

class RestaurantDashboardView extends StatefulWidget {
  final String restaurantId;

  RestaurantDashboardView({super.key, required dynamic payload})
      : restaurantId =
            payload is String ? payload : (payload['id'] as String?) ?? "";

  @override
  State<RestaurantDashboardView> createState() =>
      _RestaurantDashboardViewState();
}

class _RestaurantDashboardViewState extends State<RestaurantDashboardView> {
  @override
  void initState() {
    super.initState();
    context.read<RestaurantDashboardCubit>().initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldDarkColor(context),
      appBar: BackAppBar(
        label: LocaleKeys.restaurantDashboard.localize,
      ),
      body: BlocConsumer<RestaurantDashboardCubit, RestaurantDashboardState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state.isSuccess) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (state.info != null)
                            SizedBox(
                              height: 0.25.sh,
                              child: PropertyCard(
                                myRestaurant: true,
                                item: state.info!,
                                mealId: 'mealId',
                                favouriteRestaurant: (String id) {},
                              ),
                            ),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Label(
                                    text: state.isRestaurant?.isActive ?? false
                                        ? LocaleKeys.available.localize
                                        : LocaleKeys.notAvailable.localize,
                                    style: Styles.headerText(),
                                  )),
                                  Switch(
                                      value:
                                          state.isRestaurant?.isActive ?? false,
                                      inactiveThumbColor: Colors.white,
                                      activeTrackColor: Colors.grey,
                                      activeColor: AppColors.SECONDARY_COLOR,
                                      trackOutlineColor:
                                          MaterialStateProperty.resolveWith(
                                              (sattes) => Colors.white),
                                      onChanged: (v) async {
                                        print("vsssss${!v}");
                                        await context
                                            .read<RestaurantDashboardCubit>()
                                            .changeConnectivityStatus(v);

                                        // await context
                                        //     .read<RestaurantsCubit>()
                                        //     .changeConnectivityStatus(v)
                                        //     .then((value) => context.read<RestaurantDashboardCubit>().isRestaurant());
                                      })
                                ],
                              )),
                          const Divider(),
                          const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: RestaurantStatisticsView(),
                          ),
                          const Sizer(),
                          Padding(
                            padding: EdgeInsets.all(4.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  child: AppButton(
                                    label: LocaleKeys.editRegistration.localize,
                                    onPressed: () async {
                                      if (state.isRestaurant?.restaurantId !=
                                              null &&
                                          state.isRestaurant?.restaurantId !=
                                              '' &&
                                          state.info?.subcategoryId?.id !=
                                              null) {
                                        await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  BlocProvider<
                                                      CreateRestaurantCubit>(
                                                create: (context) =>
                                                    serviceLocator(),
                                                child: CreateRestaurantForm(
                                                    from: 'update',
                                                    restaurantId: state
                                                        .isRestaurant
                                                        ?.restaurantId,
                                                    subcategoryId: state
                                                            .info
                                                            ?.subcategoryId
                                                            ?.id ??
                                                        ''),
                                              ),
                                            ));
                                        context
                                            .read<RestaurantDashboardCubit>()
                                            .initialize();
                                      }
                                    },
                                    backColor: AppColors.PRIMARY_COLOR,
                                    style:
                                        Styles.headerText(color: Colors.white),
                                  ),
                                ),
                                const Sizer(),
                                Expanded(
                                  child: AppButton(
                                    label:
                                        LocaleKeys.deleteRegistration.localize,
                                    onPressed: () {
                                      showConfirmationDialog(
                                        context,
                                        title: LocaleKeys
                                            .deleteRegistration.localize,
                                        message: LocaleKeys
                                            .sureRemoveRestaurant.localize,
                                        onConfirm: () async {
                                          if (widget.restaurantId.isNotEmpty) {
                                            await context
                                                .read<
                                                    RestaurantDashboardCubit>()
                                                .deleteRestaurantById(context,
                                                    id: widget.restaurantId);
                                            context.pop(true);
                                            // Future.delayed(const Duration(seconds: 1),()=>context.pop(true));
                                          }
                                        },
                                      );
                                    },
                                    backColor: AppColors.PRIMARY_COLOR_DARK,
                                    style:
                                        Styles.headerText(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 15.h, left: 4.w, right: 4.w, bottom: 15.h),
                        child: AppButton(
                          label: LocaleKeys.subscribe.localize,
                          onPressed: () {
                            SubscriptionMethod().subscribe(
                                subscribeId:
                                    state.info?.subcategoryId?.id ?? '',
                                title: LocaleKeys.restaurantDashboard.localize);
                          },
                          backColor: AppColors.PRIMARY_COLOR_DARK,
                          style: Styles.headerText(color: Colors.white),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            if (state.orders?.data.orders.length != null &&
                                index <
                                    (state.orders?.data.orders.length ?? 0)) {
                              final order = state.orders!.data.orders[index];
                              return Column(
                                children: [
                                  RestaurantOrderCard(
                                    item: order,
                                    subCategoryId:
                                        state.info?.subcategoryId?.id ?? '',
                                  ),
                                  if (state.orders!.data
                                          .restaurantSubscriptionType !=
                                      'Not subscribed')
                                    Text(
                                      LocaleKeys
                                          .subscribeToContactTheClient.localize,
                                      style: Styles.headerText(
                                          color: AppColors.PRIMARY_COLOR_DARK),
                                    )
                                  else
                                    const Sizer(),
                                ],
                              );
                            }
                            return const SizedBox();
                          },
                          separatorBuilder: (context, index) => const Sizer(
                                height: 20,
                              ),
                          itemCount: state.orders?.data.orders.length ?? 0),
                    )
                  ],
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
    );
  }
}

void showConfirmationDialog(
  BuildContext context, {
  required String title,
  required String message,
  required VoidCallback onConfirm,
  VoidCallback? onCancel,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          title,
          style: Styles.headerText(color: Colors.black),
        ),
        content: Text(
          message,
          style: Styles.mediumText(color: Colors.black),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: onCancel ?? () => Navigator.of(context).pop(),
            child: Text(
              LocaleKeys.no.localize,
              style: Styles.mediumText(color: Colors.black),
            ),
          ),
          ElevatedButton(
            onPressed: onConfirm,
            child: Text(
              LocaleKeys.yes.localize,
              style: Styles.mediumText(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}

void deleteItem(BuildContext context) {
  Navigator.of(context).pop();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(LocaleKeys.deleteSuccessfully.localize)),
  );
}
