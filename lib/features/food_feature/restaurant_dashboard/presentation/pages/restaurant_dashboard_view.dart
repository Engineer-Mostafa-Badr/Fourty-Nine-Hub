import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/cubit/create_resturant_cubit.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/views/create_resturant_view.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/presentation/pages/cart_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/presentation/widgets/restaurant_statistics_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/is_restaurant_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_2_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/is_resturant_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/cubit/restaurants_list_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/widgets/subcatigories_restaurant_card.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../res/strings/labels.dart';
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
  IsRestaurantModel isRestaurantModel = IsRestaurantModel(
      restaurantId: '', approved: false, isActive: false, isRestaurant: false);
  final ApiConsumer apiConsumer =
      BaseApiConsumer(serviceLocator(), serviceLocator());

  Restaurant2Model? myRestaurant;

  Future<void> isRestaurant() async {
    final response =
        await IsResturantUsecase(serviceLocator()).call(const NoParams());
    response.fold((failure) => {}, (data) {
      setState(() {
        isRestaurantModel = data;
      });
    });
  }

  Future<void> myRes() async {
    final res = await apiConsumer
        .get('https://49dev.com/api/v1/restaurants/info-restaurant');

    res.fold((l) {}, (r) {
      if (r["data"] != null) {
        myRestaurant = Restaurant2Model.fromJson(r["data"]);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  initialize() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await myRes();
      await isRestaurant();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RestaurantDashboardCubit, RestaurantDashboardState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
              backgroundColor: scaffoldDarkColor(context),
              appBar: const BackAppBar(
                label: 'Restaurant Dashboard',
              ),
              body: Padding(
                padding: const EdgeInsets.all(4.0),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (myRestaurant != null)
                            SizedBox(
                              height: 0.25.sh,
                              child: PropertyCard(
                                  myRestaurant: true,
                                  item: myRestaurant!,
                                  mealId: 'mealId'),
                            ),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Label(
                                    text: isRestaurantModel.isActive ?? false
                                        ? Labels.available
                                        : Labels.notAvailable,
                                    style: Styles.headerText(),
                                  )),
                                  Switch(
                                      value:
                                          isRestaurantModel.isActive ?? false,
                                      inactiveThumbColor: Colors.white,
                                      activeTrackColor: Colors.grey,
                                      activeColor: AppColors.SECONDARY_COLOR,
                                      trackOutlineColor:
                                          const MaterialStatePropertyAll(
                                              Colors.white),
                                      onChanged: (v) async {
                                        await context
                                            .read<RestaurantsCubit>()
                                            .changeConnectivityStatus(v)
                                            .then((value) => isRestaurant());
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
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  child: AppButton(
                                    label: 'Edit Registration',
                                    onPressed: () async {
                                      if (isRestaurantModel.restaurantId !=
                                              null &&
                                          isRestaurantModel.restaurantId !=
                                              '' &&
                                          myRestaurant?.subcategoryId?.id !=
                                              null) {
                                        await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  BlocProvider<
                                                      CreateRestaurantCubit>(
                                                create: (context) =>
                                                    serviceLocator()
                                                      ..loadData(),
                                                child: CreateRestaurantForm(
                                                    from: 'update',
                                                    restaurantId:
                                                        isRestaurantModel
                                                            .restaurantId,
                                                    subcategoryId: myRestaurant!
                                                        .subcategoryId!.id),
                                              ),
                                            ));
                                        initialize();
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
                                    label: 'Delete Registration',
                                    onPressed: () {
                                      showConfirmationDialog(
                                        context,
                                        title: "Delete Restaurant",
                                        message:
                                            "Are you sure you want to remove this restaurant?",
                                        onConfirm: () async {
                                          if (widget.restaurantId.isNotEmpty) {
                                            await context
                                                .read<
                                                    RestaurantDashboardCubit>()
                                                .deleteRestaurantById(context,
                                                    id: widget.restaurantId);
                                            Navigator.pop(context);
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
                      child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            if (state.orders?.data.orders.length != null &&
                                index < state.orders!.data.orders.length) {
                              final order = state.orders!.data.orders[index];
                              return Column(
                                children: [
                                  RestaurantOrderCard(item: order),
                                  if (state.orders!.data
                                          .restaurantSubscriptionType !=
                                      'Not subscribed')
                                    Text(
                                      'Please Subscribe to contact the client!',
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
              ));
        });
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
              "No",
              style: Styles.mediumText(color: Colors.black),
            ),
          ),
          ElevatedButton(
            onPressed: onConfirm,
            child: Text(
              "Yes",
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
    const SnackBar(content: Text("Item deleted successfully")),
  );
}
