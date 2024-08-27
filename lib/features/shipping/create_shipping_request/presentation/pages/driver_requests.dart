import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/api/interceptors/subscription_interceptor.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/get_all_trip_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_state.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/widgets/trip_card.dart';
import 'package:fourtyninehub/features/subscripe/presentation/controllers/subscription_controller.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

class DriverRequests extends StatelessWidget {
  const DriverRequests({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<GetAllTripCubit, ShippingState>(
      builder: (context, state) {
        if (state is LoadingShippingState) {
          return Align(
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
                const SizedBox(
                  height: 30,
                ),
                const SizedBox(
                  height: 40,
                ),
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
                            padding: EdgeInsets.symmetric(horizontal: 35),
                            child: GestureDetector(
                              onTap: () {
                                //هتروح لي صفحه subscription
                                serviceLocator<SubscriptionController>()
                                    .showActiveSubscriptionAmounts(
                                        walletType: WalletTypes.balance);
                              },
                              child: Text(
                                "Subscribe to send offer / contact the client",
                                style:
                                    TextStyle(fontSize: 16, color: Colors.red),
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
    ));
  }
}
