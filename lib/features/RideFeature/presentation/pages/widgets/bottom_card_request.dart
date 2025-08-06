import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_states.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../../../../../core/utils/format_numbers.dart';
import '../../../../../service_locator/service_locator.dart';
import 'font_manager.dart';

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
      child: Builder(
        builder: (context) {
          return BlocBuilder <RideCubit, RideState>(
            builder: (context, state) {
              return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                    color: context.isDarkMode ?  AppColors.QUANTITY_COLOR : null,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if(serviceLocator<RideCubit>().tripViewers.isNotEmpty)
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xff2C2C2C) : const Color(0xffF5F5F5),
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
                                      LocaleKeys.driversDisplayYourRequest.localize,
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
                        ),
                        const SizedBox(height: 12),
                        OfferRow(rideCubit: widget.rideCubit,),
                        Row(
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
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
                              onChanged: (isAutoAccept) async {
                                await widget.rideCubit.updateTripAutoAcceptStatus(isAutoAccept: isAutoAccept);
                              },
                              activeColor: switchThumbColor,
                              inactiveThumbColor: switchThumbColor,
                              activeTrackColor: switchActiveTrack,
                              inactiveTrackColor: switchInactiveTrack,
                              trackOutlineColor: MaterialStateProperty.resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                                  return states.contains(MaterialState.selected)
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
                              backgroundColor: context.isDarkMode ? const Color(0xff2C2C2C) : const Color(0xFFF5F5F5), // Light gray background
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30), // More rounded corners
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
            }
          );
        }
      ),
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

class OfferRow extends StatelessWidget {
  const OfferRow({super.key, required this.rideCubit});
  final RideCubit rideCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: rideCubit,
      child: Builder(
        builder: (context) {
          return BlocBuilder<RideCubit, RideState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Decrease Button
                    GestureDetector(
                      onTap: () async {
                        if ((state.requestedTrip!.price! - 3) < state.requestedTrip!.lowestFare!) return;
                        await rideCubit.updateTripPriceStatus(newOfferPrice: -3);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                        decoration: BoxDecoration(
                          color: ((state.requestedTrip!.price! - 3) < state.requestedTrip!.lowestFare!) ? const Color(0xffD9D9D9) : AppColors.PRIMARY_COLOR,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child:  Text(
                          FormatNumbers().convertNumberToLocalizedString('-3', isArabic: context.isArabic),
                          style: TextStyle(color: ((state.requestedTrip!.price! - 3) < state.requestedTrip!.lowestFare!) ? AppColors.PRIMARY_COLOR : Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                    const Spacer(), // Space between buttons and text
                    // Offer Text
                     Text(
                      context.isArabic ? " ${FormatNumbers().convertNumberToLocalizedString(state.requestedTrip!.price!.toInt().toString(), isArabic: context.isArabic)} ج.م" : "EGP ${FormatNumbers().convertNumberToLocalizedString(state.requestedTrip!.price!.toInt().toString(), isArabic: context.isArabic)}",
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(), // Space between text and buttons
                    // Increase Button
                    GestureDetector(
                      onTap: () async {
                        if ((state.requestedTrip!.price! + 3) > state.requestedTrip!.highestFare!) return;
                        await rideCubit.updateTripPriceStatus(newOfferPrice: 3);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                        decoration: BoxDecoration(
                          color: ((state.requestedTrip!.price! + 3) > state.requestedTrip!.highestFare!) ? const Color(0xffD9D9D9) :  AppColors.PRIMARY_COLOR,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child:  Text(
                          FormatNumbers().convertNumberToLocalizedString('+3', isArabic: context.isArabic),
                          style: TextStyle(color:((state.requestedTrip!.price! + 3) > state.requestedTrip!.highestFare!) ? AppColors.PRIMARY_COLOR: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          );
        }
      ),
    );
  }
}