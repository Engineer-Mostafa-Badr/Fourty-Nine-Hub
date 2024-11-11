import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/common/dashboard_banner.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/all_trip_model/all_trip_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/repositories/shipping_repository.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/accept_decline_trip_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/call_message_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/create_trip_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/get_all_request_by_my_trip_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/get_my_trip_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_state.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/trip_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/pages/create_shipping_view.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/pages/create_trip_form.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/widgets/shipping_banner.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/widgets/trip_card.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

class SubCateogryShippingWidget extends StatefulWidget {
  const SubCateogryShippingWidget({
    super.key, required this.formKey,
  });
  final GlobalKey<FormState> formKey;
  @override
  State<SubCateogryShippingWidget> createState() =>
      _SubCateogryShippingWidgetState();
}

class _SubCateogryShippingWidgetState extends State<SubCateogryShippingWidget> {
  bool isButtonSheet = false;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateTripCubit, ShippingState>(
        listener: (context, state) {
      log(state.toString(), name: "lskdjlskdjflskdjf");
      if (state is SuccessCreateTrip) {
        context.go(Routes.HOME);
        showSuccessMessage(context, state.message);
      }
      if (state is FailureShippingState) {
        showErrorMessage(context, getFailureMessage(state.failure, context));
      }
      //
      // } else if (state is OTPSent) {
      //
    }, builder: (context, status) {
      if (status is LoadingShippingState) {
        return const Align(
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.PRIMARY_COLOR,
            ),
          ),
        );
      }
      return BlocBuilder<ShippingCubit, ShippingState>(
        builder: (context, state) {
          if (state is LoadingShippingState) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.PRIMARY_COLOR,
              ),
            );
          }
          if (state is SuccessGetBannerState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (state.model.mainCategory?.haveTrip ?? false) {
                if (!isButtonSheet) {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => MultiBlocProvider(
                      providers: [
                        BlocProvider(
                            create: (context) =>
                                serviceLocator<GetMyTripCubit>()),
                        BlocProvider(
                            create: (context) => serviceLocator<TripCubit>()),
                        BlocProvider(
                            create: (context) =>
                                serviceLocator<GetMyTripCubit>()),
                        BlocProvider(
                            create: (context) =>
                                serviceLocator<CallMessageCubit>()),
                      ],
                      child: showButtonSheetTrip(),
                    ),
                  );
                }
                isButtonSheet = true;
              }
            });
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  (state.model.mainCategory?.haveTrip ?? false)
                      ? BlocBuilder<GetAllRequestByMyTripCubit, ShippingState>(
                          builder: (context, state) {
                            if (state is SuccessGetLoadingTripRequests) {
                              if (state.request.isNotEmpty) {
                                return Column(
                                  children: [
                                    ...List.generate(
                                      state.request.length,
                                      (index) => RequestOfferCard(
                                        model: state.request[index],
                                      ),
                                    )
                                  ],
                                );
                              } else {
                                return const NotFoundOffers();
                              }
                            } else {
                              return const NotFoundOffers();
                            }
                          },
                        )
                      : CreateTripForm(
                          formKey: widget.formKey,
                        )
                ],
              ),
            );
          } else {
            return Container();
          }
        },
      );
    },
    );
  }

  showButtonSheetTrip() {
    return BlocBuilder<GetMyTripCubit, ShippingState>(
      builder: (context, state) {
        if (state is SuccessGetMyTripState) {
          return BlocProvider(
            create: (context) => AcceptDeclineTripCubit(
                repository: serviceLocator<ShippingRepository>()),
            child: BlocListener<AcceptDeclineTripCubit, ShippingState>(
              listener: (context, state) {
                if (state is SuccessCancelState) {
                  context.pop();

                  showSuccessMessage(context,
                      LocaleKeys.theTripHasBeenSuccessfullyClosed.tr());
                }
                if (state is FailureShippingState) {
                  showErrorMessage(
                      context, getFailureMessage(state.failure, context));
                }
              },
              child: TripCardWidget(
                yourRequest: true,
                title: LocaleKeys.yourRequest.tr(),
                buttons: false,
                model: AllTripModel(
                    id: state.model.id,
                    phone: state.model.phone,
                    time: state.model.time,
                    desc: state.model.desc,
                    price: state.model.price,
                    targetLocation: state.model.targetLocation,
                    startLocation: state.model.startLocation,
                    status: state.model.status),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
