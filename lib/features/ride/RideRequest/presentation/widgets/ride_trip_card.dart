import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/all_trip_for_driver_mode/all_trip_for_driver_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/accept_offer_by_driver_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/send_offer_by_driver_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class RideTripCard extends StatelessWidget {
  RideTripCard({super.key, required this.model});
  final AllTripForDriverModel model;
  TextEditingController sendOfferController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.red, width: 3),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 13,
                height: 13,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.green, width: 3)),
              ),
              const Sizer(),
              Flexible(
                  child: Text(
                model.fromTitle ?? "",
                style: Styles.mediumText(),
              )),
            ],
          ),
          const Sizer(
            height: 30,
          ),
          Row(
            children: [
              Container(
                width: 13,
                height: 13,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blue, width: 3)),
              ),
              const Sizer(),
              Flexible(
                  child: Text(
                model.toTitle ?? "",
                style: Styles.mediumText(),
              )),
            ],
          ),
          // Row(
          //   children: [
          //     const Icon(Icons.people),
          //     const Sizer(),
          //     Text(model.passengers.toString())
          //   ],
          // ),
          Row(
            children: [
              const Icon(Icons.attach_money_rounded),
              const Sizer(),
              Text(model.price.toString())
            ],
          ),
          Row(
            children: [
              const Icon(Icons.credit_card),
              const Sizer(),
              Text(model.paymentMethod ?? "")
            ],
          ),
          Container(
            width: double.infinity,
            height: 46,
            decoration: BoxDecoration(
                // color: const Color(0xFF0E4669),
                borderRadius: BorderRadius.circular(13)),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: context.isDarkMode ? Colors.white : Colors.black,
                ),
                const Sizer(),
                Flexible(
                  child: Text(
                    "${LocaleKeys.travelTime.tr()}: ~${formatDuration(model.duration ?? 0)} , ${LocaleKeys.Distance.tr()}: ${formatDistance(model.distance ?? 0)}",
                    style: Styles.mediumText(
                        fontWeight: FontWeight.w500,
                        color:
                            context.isDarkMode ? Colors.white : Colors.black),
                  ),
                ),
                const Sizer(),
              ],
            ),
          ),
          const Sizer(),
          AppButton(
            onPressed: () {
              if ((model.isPremium ?? false) && (model.autoAccept ?? false)) {
                if (model.id != null) {
                  context
                      .read<AcceptOfferByDriverCubit>()
                      .accept(id: model.id!);
                }
              } else {
                showBottomSheet(
                  context: context,
                  builder: (context) {
                    sendOfferController.text =
                        model.price?.toStringAsFixed(0) ?? "0";
                    return Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(color: Colors.black, blurRadius: 50)
                          ],
                          color: context.isDarkMode
                              ? AppColors.QUANTITY_COLOR
                              : Colors.white,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      width: double.infinity,
                      height: 200,
                      child: Column(
                        children: [
                          DefaultTextFormField(
                            currentController: sendOfferController,
                            hint: LocaleKeys.price.tr(),
                          ),
                          const Spacer(),
                          AppButton(
                            onPressed: () {
                              if (model.price != null && model.id != null) {
                                context.read<SendOfferByDriverCubit>().send(
                                    id: model.id ?? "",
                                    price:
                                        double.parse(sendOfferController.text));
                              }
                            },
                            label: LocaleKeys.sendYourOffer.tr(),
                            height: 40,
                            color: Colors.white,
                          )
                        ],
                      ),
                    );
                  },
                );
              }
            },
            label: (model.isPremium ?? false) && (model.autoAccept ?? false)
                ? LocaleKeys.Accept.tr()
                : LocaleKeys.sendOffer.tr(),
            width: double.infinity,
            height: 40,
            color: (model.isPremium ?? false) && (model.autoAccept ?? false)
                ? Colors.white
                : Colors.black,
            backColor: (model.isPremium ?? false) && (model.autoAccept ?? false)
                ? AppColors.PRIMARY_COLOR
                : AppColors.DARK_GRAY_COLOR,
            // padding: EdgeInsets.zero,
          )
        ],
      ),
    );
  }

  // return DefaultTabController(
  String formatDuration(int totalSeconds) {
    if (totalSeconds >= 3600) {
      // إذا كان العدد يساوي أو أكبر من ساعة (3600 ثانية)
      int hours = totalSeconds ~/ 3600;
      int minutes = (totalSeconds % 3600) ~/ 60;
      return '$hours h, $minutes min';
    } else if (totalSeconds >= 60) {
      // إذا كان العدد يساوي أو أكبر من دقيقة (60 ثانية)
      int minutes = totalSeconds ~/ 60;
      int seconds = totalSeconds % 60;
      return '$minutes min, $seconds s';
    } else {
      // إذا كان العدد أقل من دقيقة
      return '$totalSeconds s';
    }
  }

  String formatDistance(int meters) {
    if (meters >= 1000) {
      // تحويل الأمتار إلى كيلومترات
      double kilometers = meters / 1000;
      return '${kilometers.toStringAsFixed(2)} km';
    } else {
      // إذا كان العدد أقل من 1000 متر
      return '$meters m';
    }
  }
}
