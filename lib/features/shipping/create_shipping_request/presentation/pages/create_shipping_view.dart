import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/common/dashboard_banner.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/all_trip_model/all_trip_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/banner_model/banner_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/get_requests_for_loading_model/get_requests_for_loading_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/repositories/shipping_repository.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/accept_decline_trip_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/call_message_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/create_trip_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/get_all_request_by_my_trip_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/get_my_trip_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_state.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/trip_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/pages/create_trip_form.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/widgets/shipping_banner.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/widgets/trip_card.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import 'package:fourtyninehub/features/subscripe/presentation/controllers/subscription_controller.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CreateShippingView extends StatefulWidget {
  const CreateShippingView({super.key, this.selectedId});

  final String? selectedId;

  @override
  State<CreateShippingView> createState() => _CreateShippingViewState();
}

class _CreateShippingViewState extends State<CreateShippingView> {
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<GetMyTripCubit>().getMyTrip();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {},
    );
  }

  bool isButtonSheet = false;

  // GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final shippingcubit = context.read<ShippingCubit>();
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
      },
      builder: (context, status) {
        if (status is LoadingShippingState) {
          return const Expanded(
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.PRIMARY_COLOR,
              ),
            ),
          );
        }
        return Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    // minHeight: MediaQuery.of(context).size.height,
                    minWidth: MediaQuery.of(context).size.width),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      BlocBuilder<ShippingCubit, ShippingState>(
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
                                            create: (context) => serviceLocator<
                                                GetMyTripCubit>()),
                                        BlocProvider(
                                            create: (context) =>
                                                serviceLocator<TripCubit>()),
                                        BlocProvider(
                                            create: (context) => serviceLocator<
                                                GetMyTripCubit>()),
                                        BlocProvider(
                                            create: (context) => serviceLocator<
                                                CallMessageCubit>()),
                                      ],
                                      child: showButtonSheetTrip(),
                                    ),
                                  );
                                }
                                isButtonSheet = true;
                              }
                            });

                            return Column(
                              children: [
                                ShippingBanner(
                                  model: state.model,
                                  favoriteName: "Driver".tr(),
                                ),
                                // const Sizer(),
                                // لو هو مسجل
                                // if (isDriver(state.model))
                                if ((state.model.mainCategory?.isDriver ??
                                        false) &&
                                    (state.model.mainCategory
                                            ?.isDriverApproved ??
                                        false))
                                  // if(!(state.model.mainCategory?.haveTrip??false))
                                  Column(
                                    children: [
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      DashboardBanner(
                                        onTap: () => context
                                            .push(Routes.DASHBOARDDRIVERSCREEN),
                                        title: LocaleKeys.driverDashboard.tr(),
                                        subTitle: LocaleKeys
                                            .newBookingsAreWaitingYouGoToResturantDashboardAndExploreMore
                                            .tr(),
                                        route: Routes.DOCTORDASHBOARD,
                                      ),
                                    ],
                                  ),
                                // لو هو مش مسجل
                                // if ((state.model.mainCategory?.isDriver ??
                                //             false) !=
                                //         true &&
                                //     ((state.model.mainCategory?.isDriver ??
                                //             false)) !=
                                //         true)
                                if ((state.model.mainCategory?.isDriver ??
                                            false) !=
                                        true &&
                                    (state.model.mainCategory
                                                ?.isDriverApproved ??
                                            false) !=
                                        true)
                                  GestureDetector(
                                    // onTap: () => context
                                    //     .push(Routes.SHIPPING_REGISTER),
                                    onTap: () {
                                      if (context
                                          .read<UserCubit>()
                                          .isLoggedIn) {
                                        context.push(Routes.SHIPPING_REGISTER);
                                      } else {
                                        // context.push(Routes.SHIPPING_REGISTER);
                                        context.push(Routes.LOGIN);
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      child: Text(
                                        LocaleKeys
                                            .youCanEnjoyServingYourClintsUsingYourRestaurantByClickingOnTheRigesterButtonAbove
                                            .tr(),
                                        style: const TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                (state.model.mainCategory?.haveTrip ?? false)
                                    ? BlocBuilder<GetAllRequestByMyTripCubit,
                                        ShippingState>(
                                        builder: (context, state) {
                                          if (state
                                              is SuccessGetLoadingTripRequests) {
                                            if (state.request.isNotEmpty) {
                                              return Column(
                                                children: [
                                                  ...List.generate(
                                                    state.request.length,
                                                    (index) => RequestOfferCard(
                                                      model:
                                                          state.request[index],
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
                                        formKey: formKey,
                                      )
                              ],
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  bool isDriver(BannerModel model) {
    if (model.subCategories!.first.isDriver ?? false) {
      if (model.subCategories!.first.isDriverApproved ?? false) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

// BlocProvider(
//                   create: (context) => ),
  showButtonSheetTrip() {
    return BlocBuilder<GetMyTripCubit, ShippingState>(
      builder: (context, state) {
        log(state.toString(), name: "lksjdflskdjfslkdjflsdkjfd");
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

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.hint,
      this.prefixIcon,
      this.minLines,
      this.maxLines,
      this.maxLength});

  final String hint;
  final Icon? prefixIcon;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return TextField(
      minLines: minLines,
      maxLength: maxLength,
      maxLines: maxLines,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.red)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.red)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.red)),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.red)),
        fillColor: Colors.grey.shade300,
        filled: true,
        prefixIcon: prefixIcon,
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 18.sp,
        ),
      ),
      textAlign: TextAlign.right,
    );
  }
}

class NotFoundOffers extends StatelessWidget {
  const NotFoundOffers({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            LocaleKeys.yourRequestHasBeenSentYouWillReceiveOffersShortly.tr(),
            style: const TextStyle(
              fontSize: 25,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class RequestOfferCard extends StatelessWidget {
  const RequestOfferCard(
      {super.key, required this.model, this.isHistory = false});

  final GetRequestsForLoadingModel model;
  final bool isHistory;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AcceptDeclineTripCubit, ShippingState>(
      listener: (context, state) {
        log(state.toString(), name: "loadingState");
        if (state is SuccessAcceptState) {
          showSuccessMessage(
              context, LocaleKeys.theRequestHasBeenSuccessfullyApproved.tr());
          context.read<GetAllRequestByMyTripCubit>().getAllRequest();
          context.pop();
        }
        if (state is SuccessDeclineState) {
          showSuccessMessage(
              context, LocaleKeys.theRequestWasSuccessfullyRejected.tr());
          context.read<GetAllRequestByMyTripCubit>().getAllRequest();
        }
        if (state is SuccessCompleteTripState) {
          showSuccessMessage(context, LocaleKeys.tripIsCompleted.tr());
          context.read<GetAllRequestByMyTripCubit>().getAllRequest();
          context.read<ShippingCubit>().getBannerData();
        }
        // if (state is SuccessCancelState) {
        //   showSuccessMessage(context, "تم اغلاق الرحلة بنجاح");
        //   context.pop();
        // }
        if (state is FailureShippingState) {
          showErrorMessage(context, getFailureMessage(state.failure, context));
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black38
                    : Colors.white,
                border: Border.all(color: AppColors.PRIMARY_COLOR, width: 3),
                // ignore: prefer_const_literals_to_create_immutables
                boxShadow: [
                  const BoxShadow(color: Colors.black12, blurRadius: 10),
                ],
                borderRadius: BorderRadius.circular(15)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        isHistory ? "" : LocaleKeys.newOffer.tr(),
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      "${model.price}",
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 7,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          image: DecorationImage(
                            image: NetworkImage(model
                                    .driverId
                                    ?.userId
                                    ?.userProfile
                                    ?.profilePictureKey
                                    ?.mediaKey ??
                                ""),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.carModel.tr(),
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          model.driverId?.userId?.firstName ?? "",
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "${model.driverId?.trips ?? 0} ${LocaleKeys.orders.tr()}",
                          style: const TextStyle(fontSize: 15),
                        )
                      ],
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.push(Routes.TripRating, extra: model);
                          },
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              Text(
                                  "${model.driverId?.rating?.toStringAsFixed(1)}"),
                              const Text(
                                "(1)",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        if (model.isPremium ?? false)
                          Text(LocaleKeys.premium.tr())
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                // Con
                if (!isHistory)
                  (model.isAccepted ?? false)
                      ? AppButton(
                          color: Colors.white,
                          backColor: AppColors.PRIMARY_COLOR,
                          // height: 50,
                          // padding: EdgeInsets.symmetric(vertical: 0),
                          width: double.infinity,
                          onPressed: () {
                            context.read<AcceptDeclineTripCubit>().complete(
                                loadingTrip: model.loadingTripId ?? "");
                          },
                          style: Styles.mediumText(
                              fontSize: 28, color: Colors.white),
                          label: LocaleKeys.completeTrip.tr(),
                          // backgroundColor: Colors.red,
                        )
                      : Row(
                          children: [
                            Flexible(
                              child: AppButton(
                                color: Colors.white,
                                // height: 50,
                                // padding: EdgeInsets.symmetric(vertical: 0),
                                width: double.infinity,
                                onPressed: () {
                                  context
                                      .read<AcceptDeclineTripCubit>()
                                      .decline(
                                          loadingRequestId: model.id ?? "");
                                },
                                style: Styles.mediumText(
                                    fontSize: 28, color: Colors.white),
                                label: LocaleKeys.decline.tr(),
                                // backgroundColor: Colors.red,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Flexible(
                              child: AppButton(
                                // label: Labels.message,
                                // icon: Icons.message,
                                backColor: AppColors.PRIMARY_COLOR,
                                style: Styles.mediumText(
                                    fontSize: 28, color: Colors.white),
                                onPressed: () {
                                  context
                                      .read<AcceptDeclineTripCubit>()
                                      .accept(loadingRequestId: model.id ?? "");
                                },
                                label: LocaleKeys.Accept.tr(),
                              ),
                            )
                          ],
                        ),
                const SizedBox(
                  height: 10,
                ),
                if (!isHistory)
                  BlocBuilder<CallMessageCubit, ShippingState>(
                    builder: (context, state) {
                      if (state is FailureShippingState) {
                        log(getFailureMessage(state.failure, context),
                            name: "lskdjflskdjfslkdjfslkdjfslkdjf");
                      }
                      log(state.toString(),
                          name: "lskdjflskdjfslkdjfslkdjfslkdjf");
                      if (state is SuccessGetCallMessageState) {
                        log(state.data.toString(),
                            name: "lskdjflskdjfslkdjfslkdjfslkdjf");
                        return Row(
                          children: [
                            Expanded(
                              child: AppButton(
                                label: "Call".tr(),
                                color: Colors.white,
                                icon: Icons.call,
                                backColor: state.data
                                    ? AppColors.PRIMARY_COLOR
                                    : AppColors.DARK_GRAY_COLOR,
                                onPressed: () {},
                                style: Styles.mediumText(
                                    fontSize: 28, color: Colors.white),
                              ),
                            ),
                            const Sizer(
                              width: 5,
                            ),
                            Expanded(
                              child: AppButton(
                                label: LocaleKeys.message.tr(),
                                icon: Icons.message,
                                backColor: state.data
                                    ? AppColors.PRIMARY_COLOR
                                    : AppColors.DARK_GRAY_COLOR,
                                style: Styles.mediumText(
                                    fontSize: 15, color: Colors.white),
                                onPressed: () {},
                              ),
                            ),
                            const Sizer(
                              width: 5,
                            ),
                            Expanded(
                              child: AppButton(
                                label: LocaleKeys.report.tr(),
                                icon: Icons.report,
                                backColor: Colors.red,
                                style: Styles.mediumText(
                                    fontSize: 28, color: Colors.white),
                                onPressed: () {
                                  // tripCubit.report(
                                  //     loadingTripId: widget.model.id ?? "");
                                  // showBottomSheet(
                                  //   context: context,
                                  //   builder: (context) => Padding(
                                  //     padding: const EdgeInsets.all(10),
                                  //     child: ReportView(
                                  //       categoryId:
                                  //           widget.model.categoryId?.id ?? "",
                                  //       id: widget.model.id ?? "",
                                  //       loadingTripId: widget.model.id ?? "",
                                  //     ),
                                  //   ),
                                  // );
                                },
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Row(
                          children: [
                            Expanded(
                              child: AppButton(
                                label: LocaleKeys.call.tr(),
                                color: Colors.white,
                                icon: Icons.call,
                                backColor: AppColors.DARK_GRAY_COLOR,
                                onPressed: () {
                                  launchUrlString(
                                      "tel://${model.driverId?.phone}");
                                  // serviceLocator<SubscriptionController>()
                                  //     .showSubscriptionPlans(
                                  //         subCategoryId:
                                  //             "62c8bab18e28a58a3edf580d");
                                  // .showActiveSubscriptionAmounts(
                                  //     walletType: WalletTypes.balance);
                                },
                                style: Styles.mediumText(
                                    fontSize: 28, color: Colors.white),
                              ),
                            ),
                            const Sizer(
                              width: 5,
                            ),
                            Expanded(
                              child: AppButton(
                                label: LocaleKeys.message.tr(),
                                icon: Icons.message,
                                backColor: AppColors.DARK_GRAY_COLOR,
                                style: Styles.mediumText(
                                    fontSize: 28, color: Colors.white),
                                onPressed: () {
                                  // serviceLocator<SubscriptionController>()
                                  //     .showSubscriptionPlans(
                                  //         subCategoryId:
                                  //             "62c8bab18e28a58a3edf580d");
                                },
                              ),
                            ),
                            const Sizer(
                              width: 5,
                            ),
                            Expanded(
                              child: AppButton(
                                label: LocaleKeys.report.tr(),
                                icon: Icons.report,
                                backColor: Colors.red,
                                style: Styles.mediumText(
                                    fontSize: 28, color: Colors.white),
                                onPressed: () {
                                  showBottomSheet(
                                    context: context,
                                    builder: (context) => const ReportView(
                                      categoryId: "",
                                      id: "",
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
              ],
            ),
          ),
          if (!isHistory)
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: GestureDetector(
                  onTap: () {
                    //هتروح لي صفحه subscription
                    serviceLocator<SubscriptionController>()
                        .showSubscriptionPlans(
                            subCategoryId: "62c8bab18e28a58a3edf580d");
                  },
                  child: Text(
                    LocaleKeys.subscribeToContactToTheDriver.tr(),
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                  ),
                )),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
