import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/driverStatistics_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/get_all_trip_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_state.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/widgets/trip_card.dart';
import 'package:fourtyninehub/features/subscripe/presentation/controllers/subscription_controller.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

class DahsboardDriverScreen extends StatelessWidget {
  const DahsboardDriverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
              leadingWidth: 300,
              // leading: ,
              // title: Text("Pickup Dashboard"),
              actions: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(Icons.more_vert_outlined),
                )
              ],
              leading: SizedBox(
                // width: 150,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        context.pop();
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Pickup Dashboard".tr(),
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
              bottom: TabBar(
                onTap: (value) {
                  log("message");
                },
                // padding: EdgeInsets.symmetric(v),
                tabs: [
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Trips".tr(),
                            style: TextStyle(fontSize: 20),
                          ),
                          // Container(
                          //   width: 20,
                          //   height: 20,
                          //   decoration: ,
                          // )
                          // CircularProgressIndicator(

                          // )
                          IconButton(
                            onPressed: () {
                              context.read<GetAllTripCubit>().getAllTrips();
                            },
                            icon: const Icon(Icons.update),
                          )
                        ],
                      )),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Information".tr(),
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  // Text("Edit", style: TextStyle(fontSize: 20),),
                ],
              )
              // centerTitle: true,
              ),
          body: const TabBarView(
            children: [
              NewTripWidget(),
              EditTabShipping(),
            ],
          )),
    );
  }
}

class NewTripWidget extends StatelessWidget {
  const NewTripWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: double.infinity,
          ),
          // Text(
          //   "New Trips",
          //   style: TextStyle(color: AppColors.PRIMARY_COLOR, fontSize: 25),
          // ),
          // SizedBox(height: 30,),
          BlocBuilder<GetAllTripCubit, ShippingState>(
            builder: (context, state) {
              if (state is LoadingShippingState) {
                return const Align(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.PRIMARY_COLOR,
                    ),
                  ),
                );
              }
              if (state is FailureShippingState) {
                log(getFailureMessage(state.failure, context),
                    name: "jjjjjjjjjjjjjjjjjjj");
              }
              if (state is SuccessGetAllTripState) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      // const SizedBox(
                      //   height: 30,
                      // ),
                      // const SizedBox(
                      //   height: 40,
                      // ),
                      ...List.generate(
                        state.allTripList.length,
                        (index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TripCardWidget(
                                model: state.allTripList[index],
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 35),
                                  child: GestureDetector(
                                    onTap: () {
                                      //هتروح لي صفحه subscription
                                      serviceLocator<SubscriptionController>()
                                          .showActiveSubscriptionAmounts(
                                              walletType: WalletTypes.balance);
                                    },
                                    child: Text(
                                      "Subscribe to send offer / contact the client".tr(),
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.red),
                                    ),
                                  ))
                            ],
                          );
                        },
                      )
                    ],
                  ),
                );
              } else {
                return Container();
              }
            },
          )
        ],
      ),
    );
  }
}
// SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SizedBox(
//               width: double.infinity,
//             ),
//             Text(
//             //   "New Trips",
//             //   style: TextStyle(color: AppColors.PRIMARY_COLOR, fontSize: 25),
//             // ),
//             // SizedBox(height: 30,),
//             BlocBuilder<GetAllTripCubit, ShippingState>(
//               builder: (context, state) {
//                 if (state is LoadingShippingState) {
//                   return Align(
//                     child: Center(
//                       child: CircularProgressIndicator(
//                         color: AppColors.PRIMARY_COLOR,
//                       ),
//                     ),
//                   );
//                 }
//                 if (state is FailureShippingState) {
//                   log(getFailureMessage(state.failure, context),
//                       name: "jjjjjjjjjjjjjjjjjjj");
//                 }
//                 if (state is SuccessGetAllTripState) {
//                   return SingleChildScrollView(
//                     child: Column(
//                       children: [
//                         // const SizedBox(
//                         //   height: 30,
//                         // ),
//                         // const SizedBox(
//                         //   height: 40,
//                         // ),
//                         ...List.generate(
//                           state.allTripList.length,
//                           (index) {
//                             return Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 TripCardWidget(
//                                   model: state.allTripList[index],
//                                 ),
//                                 Padding(
//                                     padding:
//                                         EdgeInsets.symmetric(horizontal: 35),
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         //هتروح لي صفحه subscription
//                                         serviceLocator<SubscriptionController>()
//                                             .showActiveSubscriptionAmounts(
//                                                 walletType:
//                                                     WalletTypes.balance);
//                                       },
//                                       child: Text(
//                                         "Please Subscribe to contact the client",
//                                         style: TextStyle(
//                                             fontSize: 16, color: Colors.red),
//                                       ),
//                                     ))
//                               ],
//                             );
//                           },
//                         )
//                       ],
//                     ),
//                   );
//                 } else {
//                   return Container();
//                 }
//               },
//             )
//           ],
//         ),
//       ),

class EditTabShipping extends StatefulWidget {
  const EditTabShipping({super.key});

  @override
  State<EditTabShipping> createState() => _EditTabShippingState();
}

class _EditTabShippingState extends State<EditTabShipping> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              DriverStatisticsCubit(repository: serviceLocator())..get(),
        ),
        BlocProvider(
          create: (context) => serviceLocator<ShippingCubit>(),
          // create: (context) => ShippingCubit(repository: serviceLocator(), imageRepository: serviceLocator(), cacheService: serviceLocator()),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: BlocListener<ShippingCubit, ShippingState>(
          listener: (context, state) {
            if (state is SuccessDeleteDriver) {
              showSuccessMessage(context, state.message);
              context.push(Routes.HOME);
            }
          },
          child: BlocBuilder<DriverStatisticsCubit, ShippingState>(
            builder: (context, state) {
              log(state.toString(), name: "lksdjflskdjfldkfj");

              if (state is SuccessGetDriverStatisticsState) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      AppButton(
                        padding: 20,
                        mainAxisAlignment: MainAxisAlignment.start,
                        label: "Registertion Form".tr(),
                        onPressed: () {
                          context.push(Routes.EDITDRIVERSCREEN);
                        },
                        backColor: Colors.white,
                        color: AppColors.PRIMARY_COLOR,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AppButton(
                        widget: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Label(
                                text: "Deadline Subscription".tr(),
                                style: Styles.mediumText(
                                    color: AppColors.PRIMARY_COLOR)),
                            Label(
                                text: "${state.model.deadlineSubscription}",
                                style: Styles.mediumText(
                                    color: AppColors.PRIMARY_COLOR)),
                          ],
                        ),
                        padding: 20,
                        width: double.infinity,
                        mainAxisAlignment: MainAxisAlignment.start,
                        label: "Deadline Subscription".tr(),
                        onPressed: () {
                          // serviceLocator<SubscriptionController>()
                          //     .showSubscriptionPlans(subCategoryId: "62c8bab18e28a58a3edf580d");
                          // context.push(Routes.)
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                width: double.infinity,
                                decoration:
                                    const BoxDecoration(color: Colors.white),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      color: Colors.red,
                                    ),
                                    Text(
                                      "Subcateogry name".tr(),
                                      style: Styles.headerText(),
                                    ),
                                    Text(
                                      "Premium".tr(),
                                      style: Styles.headerText(),
                                    ),
                                    Text(
                                      "${state.model.deadlineSubscription} Day",
                                      style: Styles.headerText(),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    AppButton(
                                        color: Colors.white,
                                        backColor: AppColors.PRIMARY_COLOR,
                                        label: "Add Subscription".tr(),
                                        onPressed: () {
                                          serviceLocator<
                                                  SubscriptionController>()
                                              .showSubscriptionPlans(
                                                  subCategoryId:
                                                      "62c8bab18e28a58a3edf580d");
                                        })
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        backColor: Colors.white,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AppButton(
                        widget: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Label(
                                text: "Deadline Id".tr(),
                                style: Styles.mediumText(
                                    color: AppColors.PRIMARY_COLOR)),
                            Label(
                                text: "${state.model.deadlineId}",
                                style: Styles.mediumText(
                                    color: AppColors.PRIMARY_COLOR)),
                          ],
                        ),
                        padding: 20,
                        width: double.infinity,
                        mainAxisAlignment: MainAxisAlignment.start,
                        label: "Deadline Subscription".tr(),
                        onPressed: () {
                          log('message');
                          serviceLocator<SubscriptionController>()
                              .showSubscriptionPlans(subCategoryId: "");
                        },
                        backColor: Colors.white,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AppButton(
                        widget: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Label(
                                text: "Deadline License".tr(),
                                style: Styles.mediumText(
                                    color: AppColors.PRIMARY_COLOR)),
                            Label(
                                text: "${state.model.deadlineLicense}",
                                style: Styles.mediumText(
                                    color: AppColors.PRIMARY_COLOR)),
                          ],
                        ),
                        padding: 20,
                        width: double.infinity,
                        mainAxisAlignment: MainAxisAlignment.start,
                        label: "Deadline Id".tr(),
                        onPressed: () {},
                        backColor: Colors.white,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AppButton(
                        widget: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Label(
                                text: "Deadline Driver License".tr(),
                                style: Styles.mediumText(
                                    color: AppColors.PRIMARY_COLOR)),
                            Label(
                                text: "${state.model.deadlineId}",
                                style: Styles.mediumText(
                                    color: AppColors.PRIMARY_COLOR)),
                          ],
                        ),
                        padding: 20,
                        width: double.infinity,
                        mainAxisAlignment: MainAxisAlignment.start,
                        label: "Deadline Driver License".tr(),
                        onPressed: () {},
                        backColor: Colors.white,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AppButton(
                        widget: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Label(
                                text: "Your Trips".tr(),
                                style: Styles.mediumText(
                                    color: AppColors.PRIMARY_COLOR)),
                            Label(
                                text: "${state.model.tripCount}",
                                style: Styles.mediumText(
                                    color: AppColors.PRIMARY_COLOR)),
                          ],
                        ),
                        padding: 20,
                        width: double.infinity,
                        mainAxisAlignment: MainAxisAlignment.start,
                        label: "",
                        onPressed: () {},
                        backColor: Colors.white,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AppButton(
                        widget: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Label(
                                text: "Profit".tr(),
                                style: Styles.mediumText(
                                    color: AppColors.PRIMARY_COLOR)),
                            Label(
                                text: "${state.model.profit}",
                                style: Styles.mediumText(
                                    color: AppColors.PRIMARY_COLOR)),
                          ],
                        ),
                        padding: 20,
                        width: double.infinity,
                        mainAxisAlignment: MainAxisAlignment.start,
                        label: "",
                        onPressed: () {},
                        backColor: Colors.white,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AppButton(
                        widget: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Label(
                                text: "Clients Rating".tr(),
                                style: Styles.mediumText(
                                    color: AppColors.PRIMARY_COLOR)),
                            Label(
                                text: "${state.model.totalRating}",
                                style: Styles.mediumText(
                                    color: AppColors.PRIMARY_COLOR)),
                          ],
                        ),
                        padding: 20,
                        width: double.infinity,
                        mainAxisAlignment: MainAxisAlignment.start,
                        label: "",
                        onPressed: () {
                          context.push(Routes.MyRating);
                        },
                        backColor: Colors.white,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AppButton(
                        label: "Delete Registration".tr(),
                        onPressed: () {
                          context.read<ShippingCubit>().deleteDriver();
                        },
                        color: Colors.white,
                      )
                    ],
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}
