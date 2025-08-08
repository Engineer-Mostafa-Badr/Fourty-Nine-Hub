import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/enums/wallet_types_enums.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../cubit/get_all_trip_cubit.dart';
import '../cubit/shipping_state.dart';
import '../widgets/trip_card.dart';
import '../../../../subscripe/presentation/controllers/subscription_controller.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../../core/widget/custom_circular_progress_indicator.dart';

import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../helpers/manage_vibration.dart';

class DriverRequests extends StatelessWidget {
  const DriverRequests({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: BlocBuilder<GetAllTripCubit, ShippingState>(
        builder: (context, state) {
          if (state is LoadingShippingState) {
            return const Align(
              child: Center(
                child: CustomCircularProgressIndicator(
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 35),
                              child: GestureDetector(
                                onTap: () {
      ManageVibration.vibrate();
                                  serviceLocator<SubscriptionController>()
                                      .showActiveSubscriptionAmounts(
                                          walletType: WalletTypes.balance);
                                },
                                child: Text(
                                  LocaleKeys
                                      .subscribeToSendOfferContactTheClient
                                      .tr(),
                                  style: const TextStyle(
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
      ),
    );
  }
}