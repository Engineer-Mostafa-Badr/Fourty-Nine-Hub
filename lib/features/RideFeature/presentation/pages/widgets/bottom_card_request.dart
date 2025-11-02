import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_states.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../../../../../core/utils/format_numbers.dart';
import '../../../../../service_locator/service_locator.dart';
import 'font_manager.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class BottomCardRequest extends StatefulWidget {
  final int driversCount;
  final VoidCallback onCancel;
  final RideCubit rideCubit;

  const BottomCardRequest({
    super.key,
    required this.driversCount,
    required this.onCancel,
    required this.rideCubit,
  });

  @override
  State<BottomCardRequest> createState() => _BottomCardRequestState();
}

class _BottomCardRequestState extends State<BottomCardRequest> {
  // bool isAutomatic = false;
  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;

    final Color cardColor = isDark ? const Color(0xff2C2C2C) : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.black87;
    const Color switchActiveTrack = Colors.green;
    const Color switchInactiveTrack = Colors.white;
    const Color switchThumbColor = Color(0xFF0D0D26); // Dark navy color

    return BlocProvider.value(
      value: widget.rideCubit,
      child: Builder(builder: (context) {
        return BlocBuilder<RideCubit, RideState>(builder: (context, state) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              color: context.isDarkMode ? AppColors.QUANTITY_COLOR : null,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  serviceLocator<RideCubit>().tripViewers.isNotEmpty
                      ? Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xff2C2C2C)
                                : const Color(0xffF5F5F5),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _buildStackedAvatars(),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "${FormatNumbers().convertNumberToLocalizedString(widget.driversCount.toString(), isArabic: context.isArabic)} ",
                                      style: TextStyle(
                                        fontSize: FontSize.s14,
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                      ),
                                    ),
                                    Text(
                                      LocaleKeys
                                          .driversDisplayYourRequest.localize,
                                      style: TextStyle(
                                        fontSize: FontSize.s14,
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : Text(
                          context.isArabic
                              ? "برجاء الانتظار حتى تصلك العروض من السائقين القريبين"
                              : "Please wait for nearby drivers to send you offers",
                          style: TextStyle(
                              color: textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                  const SizedBox(height: 12),
                  OfferRow(
                    rideCubit: widget.rideCubit,
                  ),
                  Row(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7),
                        child: Text(
                          "${LocaleKeys.acceptTheNearestDriverFor.tr()} ${FormatNumbers().convertNumberToLocalizedString(state.requestedTrip?.price?.toInt().toString() ?? "0", isArabic: context.isArabic)} ${context.isArabic ? "ج.م تلقائيا" : "EGP Automatically"}",
                          style: TextStyle(
                            fontSize: 14,
                            color: textColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Switch(
                        value: state.requestedTrip?.autoAccept ?? false,
                        // onChanged: (isAutoAccept) async {
                        //   await widget.rideCubit.updateTripAutoAcceptStatus(isAutoAccept: isAutoAccept);
                        // },
                        onChanged: (isAutoAccept) async {
                          final currentAutoAccept =
                              state.requestedTrip?.autoAccept ?? false;

                          // محاولة التفعيل (من false إلى true)
                          if (!currentAutoAccept && isAutoAccept) {
                            final shouldProceed = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Center(
                                  child: Text(
                                    context.isArabic ? "تحذير" : "Alert!",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.PRIMARY_COLOR_DARK,
                                    ),
                                  ),
                                ),
                                content: Text(
                                  context.isArabic
                                      ? "كن حذرا ربما تحصل على سائق ليس لديه الاحتياجات المختاره"
                                      : "Be careful, you might get a driver who does not meet your selected needs.",
                                  textAlign: TextAlign.center,
                                ),
                                actionsPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                actions: [
                                  SizedBox(
                                    height: 50,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            // width: double.infinity,
                                            child: FilledButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(false),
                                              style: FilledButton.styleFrom(
                                                backgroundColor: AppColors
                                                    .PRIMARY_COLOR_DARK,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 14),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                              child: Text(
                                                context.isArabic
                                                    ? "إلغاء"
                                                    : "Cancel",
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: SizedBox(
                                            // width: double.infinity,
                                            child: FilledButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                              style: FilledButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.PRIMARY_COLOR,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 14),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                              child: Text(
                                                context.isArabic
                                                    ? "موافق"
                                                    : "OK",
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );

                            if (shouldProceed == true) {
                              await widget.rideCubit.updateTripAutoAcceptStatus(
                                  isAutoAccept: true);
                            }
                          }
                          // محاولة إيقاف التفعيل (من true إلى false)
                          else if (currentAutoAccept && !isAutoAccept) {
                            await widget.rideCubit.updateTripAutoAcceptStatus(
                                isAutoAccept: false);
                          }
                        },
                        activeThumbColor: switchThumbColor,
                        inactiveThumbColor: switchThumbColor,
                        activeTrackColor: switchActiveTrack,
                        inactiveTrackColor: switchInactiveTrack,
                        trackOutlineColor:
                            WidgetStateProperty.resolveWith<Color?>(
                          (Set<WidgetState> states) {
                            return states.contains(WidgetState.selected)
                                ? Colors.transparent
                                : Colors.black;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Cancel Button
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: widget.onCancel,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: context.isDarkMode
                            ? const Color(0xff2C2C2C)
                            : const Color(0xFFF5F5F5), // Light gray background
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(30), // More rounded corners
                        ),
                      ),
                      child: Text(
                        LocaleKeys.cancelOrder.tr(),
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.red, // Red text color
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      }),
    );
  }

  // Build overlapping driver avatars
  Widget _buildStackedAvatars() {
    final tripViewers = serviceLocator<RideCubit>().tripViewers;

    return SizedBox(
      width: 80,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: List.generate(
          tripViewers.length > 3 ? 3 : tripViewers.length,
          (index) {
            final viewer = tripViewers[tripViewers.length - 1 - index];
            return Positioned(
              left: index * 14.0,
              child: CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(viewer.driverImage),
              ),
            );
          },
        ),
      ),
    );
  }
}

class OfferRow extends StatefulWidget {
  const OfferRow({super.key, required this.rideCubit});
  final RideCubit rideCubit;

  @override
  State<OfferRow> createState() => _OfferRowState();
}

class _OfferRowState extends State<OfferRow> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.rideCubit,
      child: Builder(builder: (context) {
        return BlocBuilder<RideCubit, RideState>(builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Decrease Button
                GestureDetector(
                  onTap: () async {
                    ManageVibration.vibrate();
                    if (isLoading) return;
                    if ((state.requestedTrip!.price! - 3) <
                        state.requestedTrip!.lowestFare!) {
                      return;
                    }
                    setState(() {
                      isLoading = true;
                    });
                    await widget.rideCubit
                        .updateTripPriceStatus(newOfferPrice: -3);
                    setState(() {
                      isLoading = false;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 30),
                    decoration: BoxDecoration(
                      color: ((state.requestedTrip!.price! - 3) <
                              state.requestedTrip!.lowestFare!)
                          ? const Color(0xffD9D9D9)
                          : AppColors.PRIMARY_COLOR,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      FormatNumbers().convertNumberToLocalizedString('-3',
                          isArabic: context.isArabic),
                      style: TextStyle(
                          color: ((state.requestedTrip!.price! - 3) <
                                  state.requestedTrip!.lowestFare!)
                              ? AppColors.PRIMARY_COLOR
                              : Colors.white,
                          fontSize: 18),
                    ),
                  ),
                ),
                const Spacer(), // Space between buttons and text
                // Offer Text
                Text(
                  FormatNumbers().convertNumberToLocalizedString(
                      state.requestedTrip!.price!.toInt().toString(),
                      isArabic: context.isArabic),
                  style: const TextStyle(
                      fontSize: 40, fontWeight: FontWeight.bold),
                ),
                Text(
                  context.isArabic ? "  ج.م " : " EGP ",
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.PRIMARY_COLOR_DARK),
                ),
                const Spacer(), // Space between text and buttons
                // Increase Button
                GestureDetector(
                  onTap: () async {
                    ManageVibration.vibrate();
                    if (isLoading) return;
                    if ((state.requestedTrip!.price! + 3) >
                        state.requestedTrip!.highestFare!) {
                      return;
                    }
                    setState(() {
                      isLoading = true;
                    });
                    await widget.rideCubit
                        .updateTripPriceStatus(newOfferPrice: 3);
                    setState(() {
                      isLoading = false;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 30),
                    decoration: BoxDecoration(
                      color: ((state.requestedTrip!.price! + 3) >
                              state.requestedTrip!.highestFare!)
                          ? const Color(0xffD9D9D9)
                          : AppColors.PRIMARY_COLOR,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      FormatNumbers().convertNumberToLocalizedString('+3',
                          isArabic: context.isArabic),
                      style: TextStyle(
                          color: ((state.requestedTrip!.price! + 3) >
                                  state.requestedTrip!.highestFare!)
                              ? AppColors.PRIMARY_COLOR
                              : Colors.white,
                          fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      }),
    );
  }
}
