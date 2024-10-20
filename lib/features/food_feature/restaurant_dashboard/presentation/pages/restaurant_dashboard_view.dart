import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/cubit/create_resturant_cubit.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/views/create_resturant_view.dart';
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
  var restaurantId;

  RestaurantDashboardView({super.key, payload}) {
    if (payload is String) {
      restaurantId = payload;
    } else {
      restaurantId = payload['id'];
    }
  }

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
      myRestaurant = Restaurant2Model.fromJson(r);
      print("${myRestaurant!.toJson()}askln");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isRestaurant();
    myRes();
  }

  @override
  Widget build(BuildContext context) {
    // print("${isRestaurantModel!.restaurantId}asfdfadsfdsfas");
    // final controller = context.read<RestaurantDashboardCubit>()..loadData();
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
                padding: const EdgeInsets.all(4.0),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 0.25.sh,
                            child: PropertyCard(
                                myRestaurant: true,
                                item: Restaurant2Model.fromJson(const {
                                  "_id": "66ce0c0d20daf452d7a0d4eb",
                                  "name": "Not Meme xd xd 9",
                                  "subcategoryId": const {
                                    "_id": "62c8babb8e28a58a3edf581d",
                                    "nameAr": "فول/طعميه",
                                    "nameEn": "Beans/falafel"
                                  },
                                  "mainCategoryId": const {
                                    "_id": "62c8b57e9332225799fe3308",
                                    "nameAr": "اكله",
                                    "nameEn": "Food",
                                    "id": "62c8b57e9332225799fe3308"
                                  },
                                  "userId": const {
                                    "_id": "66cdef252184623620bb5337",
                                    "twitter_documentation": false,
                                    "id": "66cdef252184623620bb5337"
                                  },
                                  "restaurantMedia": const [
                                    {
                                      "_id": "670a908d5240649c258be296",
                                      "mediaKey":
                                          "https://d3j5umpuujp1ej.cloudfront.net/cars/infiniti/66cd7c4d5630606afd974fe1/8f03cd82-0252-43e0-aee2-d76a1bfe9ae6.png"
                                    },
                                    {
                                      "_id": "670a6cc06022eae749f0ee44",
                                      "mediaKey":
                                          "https://d3j5umpuujp1ej.cloudfront.net/cars/infiniti/66cd7c4d5630606afd974fe1/5be357d9-3289-45a7-bd22-ebebd1ca8732.png"
                                    },
                                    {
                                      "_id": "6706d07028f0016078bdb21e",
                                      "mediaKey":
                                          "https://d3j5umpuujp1ej.cloudfront.net/cars/infiniti/66cd7c4d5630606afd974fe1/7c3a555d-6ea7-413a-b1eb-6d193cec313d.png"
                                    }
                                  ],
                                  "government": const {
                                    "governorate_name_ar": "القاهرة",
                                    "governorate_name_en": "Cairo"
                                  },
                                  "city": const {
                                    "city_name_ar": "15 مايو",
                                    "city_name_en": "15 May"
                                  },
                                  "isActive": true,
                                  "totalRating": 3.5,
                                  "numberOfReviews": 0,
                                  "phone": "011256565551",
                                  "subscriptionType": "No subscription",
                                  "isFavorite": false,
                                  "enableOrDisableChat": "disable",
                                  "MENU": const [
                                    {
                                      "_id": "66ce0c0d20daf452d7a0d4ee",
                                      "restaurantId":
                                          "66ce0c0d20daf452d7a0d4eb",
                                      "foodName": "item 1",
                                      "price": 745,
                                      "picture": const {
                                        "_id": "66ce06ba64f63bf95e3ff1d9",
                                        "mediaKey":
                                            "https://d3j5umpuujp1ej.cloudfront.net/food/beans/falafel/66cdef252184623620bb5337/3bbedc1c-ec3a-401d-8ab9-49cf55995331.png"
                                      },
                                      "currency": "EGP",
                                      "id": "66ce0c0d20daf452d7a0d4ee"
                                    }
                                  ],
                                  "id": "66ce0c0d20daf452d7a0d4eb"
                                }),
                                mealId: 'mealId'),
                          ),

                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Label(
                                    text: isRestaurantModel.isActive!
                                        ? Labels.available
                                        : Labels.notAvailable,
                                    style: Styles.headerText(),
                                  )),
                                  // if (state.connected)
                                  //   SizedBox(
                                  //     height: 15.h,
                                  //     width: 15.w,
                                  //     child: const CircularProgressIndicator.adaptive(),
                                  //   ),
                                  Switch(
                                      value: isRestaurantModel.isActive!,
                                      inactiveThumbColor: Colors.white,
                                      inactiveTrackColor: Colors.grey,
                                      onChanged: (v) async {
                                        print(
                                            "${v}sflakkwrgbkengkl");
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
                          // Divider(),
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
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => BlocProvider<
                                                CreateRestaurantCubit>(
                                              create: (context) =>
                                                  serviceLocator()..loadData(),
                                              child: CreateRestaurantForm(
                                                  from: 'update',
                                                  restaurantId:
                                                      isRestaurantModel
                                                          .restaurantId),
                                            ),
                                          ));
                                      // context.push(Routes.CREATERESTURANT);
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
                                      _showConfirmationDialog(
                                        context,
                                        title: "Delete Restaurant",
                                        message:
                                            "Are you sure you want to remove this restaurant?",
                                        onConfirm: () async {
                                          // Perform the logout action here
                                          await context
                                              .read<RestaurantDashboardCubit>()
                                              .deleteRestaurantById(context,
                                                  id: widget.restaurantId!);
                                          Navigator.pop(context);
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
                            print(
                                '${state.orders!.data.orders.length}455555555555555555555555');
                            return Column(
                              children: [
                                RestaurantOrderCard(
                                    item: state.orders!.data.orders[index]),
                                state.orders!.data.restaurantSubscriptionType !=
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
                    )
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

// Example function to handle the deletion
void _deleteItem(BuildContext context) {
  // Close the dialog
  Navigator.of(context).pop();

  // Show a snackbar after deletion
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Item deleted successfully")),
  );
}
