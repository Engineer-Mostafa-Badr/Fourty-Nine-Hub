import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/cubit/create_resturant_cubit.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/views/create_resturant_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/presentation/widgets/restaurant_statistics_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/is_restaurant_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/cubit/restaurants_list_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../res/strings/labels.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../service_locator/service_locator.dart';
import '../cubit/restaurant_dashboard_cubit.dart';
import '../widgets/restaurant_order_card.dart';

class RestaurantDashboardView extends StatelessWidget {
  final IsRestaurantModel isRestaurantModel;

  const RestaurantDashboardView({super.key, required this.isRestaurantModel});

  @override
  Widget build(BuildContext context) {
    print("${isRestaurantModel.restaurantId}asfdfadsfdsfas");
    final controller = context.read<RestaurantDashboardCubit>()..loadData();
    return BlocConsumer<RestaurantDashboardCubit, RestaurantDashboardState>(
        listener: (context, state) {},
        builder: (context, state) {
          // print(state.orders!.length.toString()+'455555555555555555555555');

          return Scaffold(
              appBar: AppBar(
                title: Text(
                  'Restaurant Dashboard',
                  style: Styles.headerText(),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child:
                          BlocConsumer<RestaurantsCubit, RestaurantsListState>(
                        listener: (context, state) {
                          // TODO: implement listener
                        },
                        builder: (context, state) {
                          return Row(
                            children: [
                              Expanded(
                                  child: Label(
                                text: context
                                            .watch<RestaurantsCubit>()
                                            .state
                                            .isResturant!
                                            .isActive ??
                                        false
                                    ? Labels.connected
                                    : Labels.notConnected,
                                style: Styles.headerText(),
                              )),
                              // if (state.connected)
                              //   SizedBox(
                              //     height: 15.h,
                              //     width: 15.w,
                              //     child: const CircularProgressIndicator.adaptive(),
                              //   ),
                              Switch(
                                  value: context
                                          .watch<RestaurantsCubit>()
                                          .state
                                          .isResturant!
                                          .isActive ??
                                      isRestaurantModel.isActive!,
                                  inactiveThumbColor: Colors.white,
                                  inactiveTrackColor: Colors.grey,
                                  onChanged: (v) async => await context
                                      .read<RestaurantsCubit>()
                                      .changeConnectivityStatus(v))
                            ],
                          );
                        },
                      ),
                    ),
                    // Divider(),

                    const RestaurantStatisticsView(),
                    // Divider(),
                    const Sizer(),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4),
                            child: AppButton(
                              label: 'Edit Registration',
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          BlocProvider<CreateRestaurantCubit>(
                                        create: (context) => serviceLocator(),
                                        child: CreateRestaurantForm(
                                            from: 'update',
                                            restaurantId:
                                                isRestaurantModel.restaurantId),
                                      ),
                                    ));
                                // context.push(Routes.CREATERESTURANT);
                              },
                              backColor: AppColors.PRIMARY_COLOR,
                              style: Styles.headerText(color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4),
                            child: AppButton(
                              label: 'Delete Registration',
                              onPressed: () {
                                _showConfirmationDialog(
                                  context,
                                  title: "Delete Restaurant",
                                  message:
                                      "Are you sure you want to remove this restaurant?",
                                  onConfirm: () async {
                                    // Perform the logout action here
                                    await controller.deleteRestaurantById(
                                        context,
                                        id: isRestaurantModel.restaurantId!);
                                    Navigator.pop(context);
                                  },
                                );
                              },
                              backColor: AppColors.PRIMARY_COLOR_DARK,
                              style: Styles.headerText(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: ListView.separated(
                          itemBuilder: (context, index) {
                            print(
                                '${state.orders!.data.orders.length}455555555555555555555555');
                            return Column(
                              children: [
                                RestaurantOrderCard(
                                    item: state.orders!.data.orders[index]),
                                state.orders!.data.restaurantSubscriptionType ==
                                        'Not subscribed'
                                    ? Text(
                                        'Please Subscribe to contact the client!',
                                        style: Styles.headerText(
                                            color:
                                                AppColors.PRIMARY_COLOR_DARK),
                                      )
                                    : const Sizer(),
                              ],
                            );
                          },
                          separatorBuilder: (context, index) => const Sizer(
                                height: 20,
                              ),
                          itemCount: state.orders?.data.orders.length ?? 0),
                    ),
                  ],
                ),
              ));
        });
  }
}

// Generalized function to show the confirmation dialog
void _showConfirmationDialog(
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
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: onCancel ?? () => Navigator.of(context).pop(),
            child: Text("No"),
          ),
          ElevatedButton(
            onPressed: onConfirm,
            child: Text("Yes"),
          ),
        ],
      );
    },
  );
}

// Example function to handle the deletion
void _deleteItem(BuildContext context) {
  // Close the dialog
  Navigator.of(context).pop();

  // Show a snackbar after deletion
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Item deleted successfully")),
  );
}
