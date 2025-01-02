import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/domain/entities/complete_seat_param.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/domain/entities/verify_otp_param.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/cubits/verify_complet_driver/cubit/verify_complete_driver_cubit.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/widgets/poly_line_with_google_map.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/domain/entities/get_all_trips_entity.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/cubits/get_currency/cubit/get_currency_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/views/widgets/card.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/available_trip_button.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class AcceptedCardForDriver extends StatelessWidget {
  const AcceptedCardForDriver({super.key, required this.entity});
  final CarpoolTripParam entity;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            entity.comfort
                ? Text(LocaleKeys.comfort.localize,
                    style: Styles.mediumText(
                        color: context.isDarkMode
                            ? AppColors.PRIMARY_COLOR_DARK
                            : AppColors.PRIMARY_COLOR_LIGHT,
                        fontWeight: FontWeight.w600))
                : const SizedBox(),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text('${entity.priceForDriver} ',
                        style: Styles.headerText(
                            fontSize: 36,
                            color: AppColors.CHECK_MARK_COLOR,
                            fontWeight: FontWeight.w600)),
                    BlocBuilder<GetCurrencyCubit, GetCurrencyState>(
                      builder: (context, state) {
                        return Text(
                          context.isArabic
                              ? BlocProvider.of<GetCurrencyCubit>(context)
                                  .currnecyAr
                              : BlocProvider.of<GetCurrencyCubit>(context)
                                  .currnecyEn,
                          style: Styles.mediumText(
                              fontWeight: FontWeight.bold,
                              color: AppColors.SECONDARY_COLOR),
                        );
                      },
                    ),
                  ],
                ),
                Text("3 ${LocaleKeys.seat.localize}",
                    style: Styles.mediumText(
                      color: context.isDarkMode
                          ? AppColors.LIGHT_COLOR
                          : AppColors.PRIMARY_COLOR_LIGHT,
                    )),
              ],
            ),
          ],
        ),
        // AvilableRoutesBarInfo(entity: entity),
        Row(
          children: [
            const Spacer(),
            BlocProvider(
              create: (context) => VerifyCompleteDriverCubit(
                  verifyOtpCompleteSeatDriverRemoteDataSource:
                      serviceLocator()),
              child: AcceptedCardImage(
                isOtpVerified: entity.locations[0].verifiedOtp,
                tripId: entity.id,
                bookedUser: entity.locations[0].bookedUser,
              ),
            ),
            const Spacer(),
            BlocProvider(
              create: (context) => VerifyCompleteDriverCubit(
                  verifyOtpCompleteSeatDriverRemoteDataSource:
                      serviceLocator()),
              child: AcceptedCardImage(
                isOtpVerified: entity.locations[1].verifiedOtp,
                tripId: entity.id,
                bookedUser: entity.locations[1].bookedUser,
              ),
            ),
            const Spacer(),
            BlocProvider(
              create: (context) => VerifyCompleteDriverCubit(
                  verifyOtpCompleteSeatDriverRemoteDataSource:
                      serviceLocator()),
              child: AcceptedCardImage(
                isOtpVerified: entity.locations[2].verifiedOtp,
                tripId: entity.id,
                bookedUser: entity.locations[2].bookedUser,
              ),
            ),
            const Spacer(),
          ],
        ),

        const Sizer(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DateTime.now()
                        .difference(DateTime.parse(entity.createdAt.toString()))
                        .inMinutes <
                    60
                ? Text(
                    "  ${DateTime.now().difference(DateTime.parse(entity.createdAt.toString())).inMinutes} ${LocaleKeys.minutesAgo.localize}",
                    style: Styles.headerText(fontSize: 24))
                : DateTime.now()
                            .difference(
                                DateTime.parse(entity.createdAt.toString()))
                            .inMinutes <
                        1440
                    ? Text(
                        "  ${DateTime.now().difference(DateTime.parse(entity.createdAt.toString())).inHours} ${LocaleKeys.hoursAgo.localize}",
                        style: Styles.headerText(fontSize: 24))
                    : Text(
                        "  ${DateTime.now().difference(DateTime.parse(entity.createdAt.toString())).inDays} ${LocaleKeys.daysAgo.localize}",
                        style: Styles.headerText(fontSize: 24)),
            const Spacer(),
            Text(entity.womenOnly == true ? LocaleKeys.womenOnly.localize : '',
                style: Styles.headerText(
                    fontSize: 24, color: AppColors.SECONDARY_COLOR)),
          ],
        ),
        const Sizer(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: AvaialbleTripsButton(
                title: LocaleKeys.viewRoute.localize,
                color: AppColors.PRIMARY_COLOR,
                onTap: () async {
                  await openGoogleMapsWithRoute(entity.polyline ?? "");
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class AcceptedCardImage extends StatefulWidget {
  final BookedUser? bookedUser;
  final String tripId;
  final bool isOtpVerified;
  const AcceptedCardImage(
      {super.key,
      required this.bookedUser,
      required this.isOtpVerified,
      required this.tripId});

  @override
  State<AcceptedCardImage> createState() => _AcceptedCardImageState();
}

class _AcceptedCardImageState extends State<AcceptedCardImage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<VerifyCompleteDriverCubit, VerifyCompleteDriverState>(
      listener: (context, state) async {
        if (state is CompleteSeatLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.PRIMARY_COLOR,
                ),
              );
            },
          );
        } else if (state is GetAcceptedTripSuccess) {
        } else if (state is CompleteSeatSuccess) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();

          showSuccessMessage(context, LocaleKeys.done.localize);
          BlocProvider.of<VerifyCompleteDriverCubit>(context)
              .getAcceptedTrips();
        } else if (state is CompleteSeatFailure) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();

          showErrorMessage(context, LocaleKeys.failedTryAgain.localize);
          BlocProvider.of<VerifyCompleteDriverCubit>(context)
              .getAcceptedTrips();
        } else if (state is VerifyOtpLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.PRIMARY_COLOR,
                ),
              );
            },
          );
        } else if (state is VerifyOtpSuccess) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();

          showSuccessMessage(
              context, LocaleKeys.otpVerifiedSuccessfully.localize);
          BlocProvider.of<VerifyCompleteDriverCubit>(context)
              .getAcceptedTrips();
        } else if (state is VerifyOtpFailure) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();

          showErrorMessage(context, LocaleKeys.invalidOtp.localize);
          BlocProvider.of<VerifyCompleteDriverCubit>(context)
              .getAcceptedTrips();
        }
      },
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              String otpSaved = "";

              final parentContext = context;
              widget.bookedUser != null
                  ? showModalBottomSheet(
                      backgroundColor: AppColors.BACKGROUND_COLOR,
                      context: context,
                      builder: (context) {
                        return Center(
                          child: Container(
                            height: widget.isOtpVerified
                                ? MediaQuery.of(context).size.height * 0.4
                                : MediaQuery.of(context).size.height * 0.8,
                            decoration: BoxDecoration(
                              color: AppColors.BACKGROUND_COLOR,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                !widget.isOtpVerified
                                    ? Column(
                                        children: [
                                          Text(
                                            LocaleKeys.enterUserOtp.localize,
                                            style: Styles.headerText(),
                                          ),
                                          Directionality(
                                            textDirection: TextDirection.ltr,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 24,
                                                      vertical: 8),
                                              child: PinCodeTextField(
                                                appContext: context,
                                                length: 6,
                                                onChanged: (value) {
                                                  print("value $value \n");
                                                  otpSaved =
                                                      value; // Update OTP on change
                                                },
                                                animationType:
                                                    AnimationType.fade,
                                                pinTheme: PinTheme(
                                                  shape: PinCodeFieldShape.box,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  activeFillColor:
                                                      Colors.grey[200],
                                                  selectedFillColor:
                                                      Colors.grey[300],
                                                  inactiveFillColor:
                                                      Colors.grey[100],
                                                  fieldHeight: 50,
                                                  fieldWidth: 40,
                                                  activeColor: Colors.blue,
                                                  selectedColor: Colors.blue,
                                                ),
                                                backgroundColor:
                                                    AppColors.BACKGROUND_COLOR,
                                                keyboardType:
                                                    TextInputType.number,
                                                cursorColor: Colors.blue,
                                                animationDuration:
                                                    const Duration(
                                                        milliseconds: 300),
                                                beforeTextPaste: (text) {
                                                  // Allow pasting
                                                  return true;
                                                },
                                                onCompleted: (data) {
                                                  otpSaved = data;
                                                  print(
                                                      "otpSaved $otpSaved \n");
                                                  print(data);
                                                },
                                              ),
                                            ),
                                          ),
                                          const Sizer(),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 24),
                                            child: AvaialbleTripsButton(
                                              color: parentContext
                                                      .isDarkMode // Use the saved context
                                                  ? AppColors.SECONDARY_COLOR
                                                  : AppColors.PRIMARY_COLOR,
                                              title:
                                                  LocaleKeys.confirm.localize,
                                              onTap: () async {
                                                try {
                                                  await BlocProvider.of<
                                                              VerifyCompleteDriverCubit>(
                                                          parentContext) // Use the saved context
                                                      .verifyUserOtp(
                                                    verifyOtpParam:
                                                        VerifyOtpParam(
                                                      driverLocation: [],
                                                      otp: otpSaved,
                                                      userId: widget
                                                              .bookedUser?.id ??
                                                          "",
                                                    ),
                                                    tripId: widget.tripId,
                                                  );
                                                } catch (e) {
                                                  // Handle the error gracefully
                                                  print("Error: $e");
                                                }
                                              },
                                            ),
                                          )
                                        ],
                                      )
                                    : const SizedBox(),
                                !widget.isOtpVerified
                                    ? const Spacer(
                                        flex: 2,
                                      )
                                    : const SizedBox(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24),
                                  child: Text(
                                    LocaleKeys.ifUserReachedClick.localize,
                                    style: Styles.mediumText(
                                        color: context.isDarkMode
                                            ? AppColors.SECONDARY_COLOR
                                            : AppColors.PRIMARY_COLOR),
                                  ),
                                ),
                                const Sizer(),
                                BlocProvider(
                                  create: (context) => VerifyCompleteDriverCubit(
                                      verifyOtpCompleteSeatDriverRemoteDataSource:
                                          serviceLocator()),
                                  child: AbsorbPointer(
                                    absorbing: !widget.isOtpVerified,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24),
                                      child: AvaialbleTripsButton(
                                        color: widget.isOtpVerified
                                            ? AppColors.SECONDARY_COLOR
                                            : AppColors.GREY_DARK_COLOR,
                                        title: LocaleKeys.reached.localize,
                                        onTap: () async {
                                          await BlocProvider.of<
                                                      VerifyCompleteDriverCubit>(
                                                  parentContext)
                                              .completeSeat(
                                                  completeSeatParam:
                                                      CompleteSeatParam(
                                                          tripId: widget.tripId,
                                                          userSeat: widget
                                                                  .bookedUser
                                                                  ?.id ??
                                                              ""));
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                const Spacer(
                                  flex: 2,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : const SizedBox();
            },
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: widget.bookedUser != null
                        ? Colors.red
                        : Colors.transparent,
                    width: 3),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    widget.bookedUser?.gender != null
                        ? widget.bookedUser?.gender.toLowerCase() == 'female'
                            ? Assets.femaleImagePlacehlder
                            : Assets.maleImagePlaceholder
                        : Assets.tripjoin,
                    fit: BoxFit.contain, // Cover the entire circle
                    width: 60,
                  ),
                ),
              ),
            ),
          ),
          Text(
            widget.bookedUser?.firstName ?? LocaleKeys.free.localize,
            style: TextStyle(
                color: context.isDarkMode
                    ? AppColors.SECONDARY_COLOR
                    : AppColors.PRIMARY_COLOR),
          )
        ],
      ),
    );
  }
}
