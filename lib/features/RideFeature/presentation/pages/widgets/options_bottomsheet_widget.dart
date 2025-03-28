import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_states.dart';

import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../res/style/app_colors.dart';

class OptionsBottomsheetWidget extends StatefulWidget {
  const OptionsBottomsheetWidget({super.key, required this.rideCubit, required this.selectedCategoryPrice, required this.selectedCategoryName});

  final RideCubit rideCubit;
  final double selectedCategoryPrice;
  final String selectedCategoryName;

  @override
  State<OptionsBottomsheetWidget> createState() =>
      _OptionsBottomsheetWidgetState();
}

class _OptionsBottomsheetWidgetState extends State<OptionsBottomsheetWidget> {

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.rideCubit,
      child: BlocBuilder<RideCubit, RideState>(
        builder: (context, state) {
          return Builder(
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                    children: [
                      switchWidget(
                        text: LocaleKeys.comfort.tr(),
                        valuee: widget.rideCubit.isComfort,
                        onChanged: (value) {
                            widget.rideCubit.isComfort = value;
                            widget.rideCubit.emitRefreshState();
                        },
                      ),
                      switchWidget(
                        text: LocaleKeys.noSmoker.tr(),
                        valuee: widget.rideCubit.isNonSmoker,
                        onChanged: (value) {
                            widget.rideCubit.isNonSmoker = value;
                            widget.rideCubit.emitRefreshState();
                        },
                      ),
                      switchWidget(
                        text: LocaleKeys.autoAccept.tr(),
                        valuee: widget.rideCubit.isAutoAccept,
                        onChanged: (value) {
                            widget.rideCubit.isAutoAccept = value;
                            widget.rideCubit.emitRefreshState();
                        },
                      ),
                      switchWidget(
                        text: LocaleKeys.record.tr(),
                        valuee: widget.rideCubit.isRecord,
                        onChanged: (value) {
                            widget.rideCubit.isRecord = value;
                            widget.rideCubit.emitRefreshState();
                        },
                      ),
                       // const SizedBox(height: 15),
                        AppButton(
                            width: double.infinity,
                            label: context.isArabic? "تفعيل" : "Apply",
                            onPressed: () {
                              // if (widget.selectedCategoryName == "Captain") {
                              //   if(widget.rideCubit.isComfort && !widget.rideCubit.isComfortIsAdded){
                              //     state.rideExpectedPrice?.priceForCaptain += state.rideExpectedPrice?.comfort ?? 0.0;
                              //     widget.rideCubit.isComfortIsAdded = true;
                              //   }
                              //   else if(widget.rideCubit.isComfort && widget.rideCubit.isComfortIsAdded){
                              //     state.rideExpectedPrice?.priceForCaptain -= state.rideExpectedPrice?.comfort ?? 0.0;
                              //     widget.rideCubit.isComfortIsAdded = false;
                              //   }
                              //
                              //   if(widget.rideCubit.isNonSmoker && !widget.rideCubit.isNonSmokerIsAdded){
                              //     state.rideExpectedPrice?.priceForCaptain += state.rideExpectedPrice?.nonSmoking ?? 0.0;
                              //     widget.rideCubit.isNonSmokerIsAdded = true;
                              //   }
                              //   else if(widget.rideCubit.isNonSmoker && widget.rideCubit.isNonSmokerIsAdded){
                              //     state.rideExpectedPrice?.priceForCaptain -= state.rideExpectedPrice?.nonSmoking ?? 0.0;
                              //     widget.rideCubit.isNonSmokerIsAdded = false;
                              //   }
                              //
                              //   if(widget.rideCubit.isAutoAccept && !widget.rideCubit.isAutoAcceptIsAdded){
                              //     state.rideExpectedPrice?.priceForCaptain += state.rideExpectedPrice?.autoAccept ?? 0.0;
                              //     widget.rideCubit.isAutoAcceptIsAdded = true;
                              //   }
                              //   else if(widget.rideCubit.isAutoAcceptIsAdded && widget.rideCubit.isAutoAccept){
                              //     state.rideExpectedPrice?.priceForCaptain -= state.rideExpectedPrice?.autoAccept ?? 0.0;
                              //     widget.rideCubit.isAutoAcceptIsAdded = false;
                              //   }
                              // }
                              // else if (widget.selectedCategoryName == "Scooter") {
                              //   if(widget.rideCubit.isComfort && !widget.rideCubit.isComfortIsAdded){
                              //     state.rideExpectedPrice?.priceForScooter += state.rideExpectedPrice?.comfort ?? 0.0;
                              //     widget.rideCubit.isComfortIsAdded = true;
                              //   }
                              //   else if(widget.rideCubit.isComfort && widget.rideCubit.isComfortIsAdded){
                              //     state.rideExpectedPrice?.priceForScooter -= state.rideExpectedPrice?.comfort ?? 0.0;
                              //     widget.rideCubit.isComfortIsAdded = false;
                              //   }
                              //
                              //   if(widget.rideCubit.isNonSmoker && !widget.rideCubit.isNonSmokerIsAdded){
                              //     state.rideExpectedPrice?.priceForScooter += state.rideExpectedPrice?.nonSmoking ?? 0.0;
                              //     widget.rideCubit.isNonSmokerIsAdded = true;
                              //   }
                              //   else if(widget.rideCubit.isNonSmoker && widget.rideCubit.isNonSmokerIsAdded){
                              //     state.rideExpectedPrice?.priceForScooter -= state.rideExpectedPrice?.nonSmoking ?? 0.0;
                              //     widget.rideCubit.isNonSmokerIsAdded = false;
                              //   }
                              //
                              //   if(widget.rideCubit.isAutoAccept && !widget.rideCubit.isAutoAcceptIsAdded){
                              //     state.rideExpectedPrice?.priceForScooter += state.rideExpectedPrice?.autoAccept ?? 0.0;
                              //     widget.rideCubit.isAutoAcceptIsAdded = true;
                              //   }
                              //   else if(widget.rideCubit.isAutoAcceptIsAdded && widget.rideCubit.isAutoAccept){
                              //     state.rideExpectedPrice?.priceForScooter -= state.rideExpectedPrice?.autoAccept ?? 0.0;
                              //     widget.rideCubit.isAutoAcceptIsAdded = false;
                              //   }
                              // }
                              // else if (widget.selectedCategoryName == "Taxi") {
                              //   if(widget.rideCubit.isComfort && !widget.rideCubit.isComfortIsAdded){
                              //     state.rideExpectedPrice?.priceForTaxi += state.rideExpectedPrice?.comfort ?? 0.0;
                              //     widget.rideCubit.isComfortIsAdded = true;
                              //   }
                              //   else if(widget.rideCubit.isComfort && widget.rideCubit.isComfortIsAdded){
                              //     state.rideExpectedPrice?.priceForTaxi -= state.rideExpectedPrice?.comfort ?? 0.0;
                              //     widget.rideCubit.isComfortIsAdded = false;
                              //   }
                              //
                              //   if(widget.rideCubit.isNonSmoker && !widget.rideCubit.isNonSmokerIsAdded){
                              //     state.rideExpectedPrice?.priceForTaxi += state.rideExpectedPrice?.nonSmoking ?? 0.0;
                              //     widget.rideCubit.isNonSmokerIsAdded = true;
                              //   }
                              //   else if(widget.rideCubit.isNonSmoker && widget.rideCubit.isNonSmokerIsAdded){
                              //     state.rideExpectedPrice?.priceForTaxi -= state.rideExpectedPrice?.nonSmoking ?? 0.0;
                              //     widget.rideCubit.isNonSmokerIsAdded = false;
                              //   }
                              //
                              //   if(widget.rideCubit.isAutoAccept && !widget.rideCubit.isAutoAcceptIsAdded){
                              //     state.rideExpectedPrice?.priceForTaxi += state.rideExpectedPrice?.autoAccept ?? 0.0;
                              //     widget.rideCubit.isAutoAcceptIsAdded = true;
                              //   }
                              //   else if(widget.rideCubit.isAutoAcceptIsAdded && widget.rideCubit.isAutoAccept){
                              //     state.rideExpectedPrice?.priceForTaxi -= state.rideExpectedPrice?.autoAccept ?? 0.0;
                              //     widget.rideCubit.isAutoAcceptIsAdded = false;
                              //   }
                              // }
                              // else if (widget.selectedCategoryName == "Suv") {
                              //   if(widget.rideCubit.isComfort && !widget.rideCubit.isComfortIsAdded){
                              //     state.rideExpectedPrice?.priceForSUV += state.rideExpectedPrice?.comfort ?? 0.0;
                              //     widget.rideCubit.isComfortIsAdded = true;
                              //   }
                              //   else if(widget.rideCubit.isComfort && widget.rideCubit.isComfortIsAdded){
                              //     state.rideExpectedPrice?.priceForSUV -= state.rideExpectedPrice?.comfort ?? 0.0;
                              //     widget.rideCubit.isComfortIsAdded = false;
                              //   }
                              //
                              //   if(widget.rideCubit.isNonSmoker && !widget.rideCubit.isNonSmokerIsAdded){
                              //     state.rideExpectedPrice?.priceForSUV += state.rideExpectedPrice?.nonSmoking ?? 0.0;
                              //     widget.rideCubit.isNonSmokerIsAdded = true;
                              //   }
                              //   else if(widget.rideCubit.isNonSmoker && widget.rideCubit.isNonSmokerIsAdded){
                              //     state.rideExpectedPrice?.priceForSUV -= state.rideExpectedPrice?.nonSmoking ?? 0.0;
                              //     widget.rideCubit.isNonSmokerIsAdded = false;
                              //   }
                              //
                              //   if(widget.rideCubit.isAutoAccept && !widget.rideCubit.isAutoAcceptIsAdded){
                              //     state.rideExpectedPrice?.priceForSUV += state.rideExpectedPrice?.autoAccept ?? 0.0;
                              //     widget.rideCubit.isAutoAcceptIsAdded = true;
                              //   }
                              //   else if(widget.rideCubit.isAutoAcceptIsAdded && widget.rideCubit.isAutoAccept){
                              //     state.rideExpectedPrice?.priceForSUV -= state.rideExpectedPrice?.autoAccept ?? 0.0;
                              //     widget.rideCubit.isAutoAcceptIsAdded = false;
                              //   }
                              // }
                              // widget.rideCubit.emitRefreshState();
                              Navigator.pop(context);
                            },
                            backColor: AppColors.PRIMARY_COLOR),
                    ],
                  ),
              );
            }
          );
        }
      )
    );
  }

  Widget switchWidget(
      {required String? text,
      required bool? valuee,
      Function(bool)? onChanged}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text ?? '',
            style:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        Transform.scale(
          scale: 0.75,
          child: Switch(
            value: valuee ?? false,
            activeColor: AppColors.PRIMARY_COLOR,
            inactiveThumbColor: AppColors.PRIMARY_COLOR,
            trackOutlineColor: WidgetStateProperty.all<Color>(
              AppColors.PRIMARY_COLOR,
            ),
            activeTrackColor: const Color(0xff19D176),
            inactiveTrackColor: AppColors.whiteColor,
            onChanged: onChanged ??
                (value) {
                  setState(() {
                    valuee = value;
                  });
                },
          ),
        ),
      ],
    );
  }
}
