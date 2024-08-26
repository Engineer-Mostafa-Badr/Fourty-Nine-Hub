import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/get_all_trip_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_state.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/widgets/trip_card.dart';
import 'package:fourtyninehub/features/subscripe/presentation/controllers/subscription_controller.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
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
                    const Text(
                      "Pickup Dashboard",
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
                          const Text(
                            "Trips",
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
                    child: const Text(
                      "Edit",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  // Text("Edit", style: TextStyle(fontSize: 20),),
                ],
              )
              // centerTitle: true,
              ),
          body: TabBarView(
            children: [
              const NewTripWidget(),
              Container(),
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
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 35),
                                    child: GestureDetector(
                                      onTap: () {
                                        //هتروح لي صفحه subscription
                                        serviceLocator<SubscriptionController>()
                                            .showActiveSubscriptionAmounts(
                                                walletType:
                                                    WalletTypes.balance);
                                      },
                                      child: const Text(
                                        "Subscribe to send offer / contact the client",
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