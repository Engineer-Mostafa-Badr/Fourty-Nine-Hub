import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/all_trip_no_socket_model/all_trip_no_socket_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/create_offer_no_socket_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/NoSocket/send_offer_no_socket_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/call_message_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_state.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class TripOfferCardNoScoket extends StatefulWidget {
  const TripOfferCardNoScoket({super.key, required this.model});
  final AllTripNoSocketModel model;

  @override
  State<TripOfferCardNoScoket> createState() => _TripOfferCardNoScoketState();
}

class _TripOfferCardNoScoketState extends State<TripOfferCardNoScoket> {
  TextEditingController price = TextEditingController();
  @override
  void initState() {
    super.initState();
    price.text = widget.model.price.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 3),
          borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  children: [
                    Text(
                      LocaleKeys.newRide.tr(),
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : AppColors.PRIMARY_COLOR,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        " ${widget.model.status}",
                        style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    '${widget.model.price?.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.calendar_month),
                    Flexible(
                      child: Text(
                        widget.model.time ?? "",
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(Icons.people),
              const SizedBox(
                width: 5,
              ),
              Flexible(
                child: Text(
                  widget.model.passengers.toString(),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const SizedBox(height: 5),
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 5),
                    shape: BoxShape.circle),
              ),
              const SizedBox(
                width: 4,
              ),
              Expanded(
                child: Text(
                  widget.model.fromTitle ?? "",
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 5),
                    shape: BoxShape.circle),
              ),
              const SizedBox(
                width: 4,
              ),
              Expanded(
                child: Text(
                  widget.model.toTitle ?? "",
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const SizedBox(height: 10),
          Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              if (!(widget.model.acceptedReq ?? false))
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        style: Styles.mediumText(
                            fontSize: 28, color: Colors.white),
                        label: LocaleKeys.sendOffer.tr(),
                        onPressed: () {
      ManageVibration.vibrate();
                          context.read<SendOfferNoSocketCubit>().send(
                              tripId: widget.model.id ?? "",
                              model: CreateOfferNoSocketModel(
                                  isPremium: widget.model.isPremium,
                                  price: price.text.isEmpty
                                      ? widget.model.price!
                                      : double.parse(price.text),
                                  subcategoryId: widget.model.categoryId));
                        },
                        backColor: AppColors.PRIMARY_COLOR,
                        color: Colors.white,
                        // height: 40,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: DefaultTextFormField(
                        currentFocusNode: FocusNode(),
                        currentController: price,
                        hint: widget.model.price.toString(),
                        // constraints: const BoxConstraints(
                        //   maxHeight: kToolbarHeight * .6,
                        //   minHeight: kToolbarHeight * .6,
                        // ),
                        keyboardType: TextInputType.number,
                      ),
                    )
                  ],
                ),
              const SizedBox(
                height: 10,
              ),
              BlocBuilder<CallMessageCubit, ShippingState>(
                builder: (context, state) {
                  if (state is FailureShippingState) {}
                  if (state is SuccessGetCallMessageState) {
                    return Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            label: LocaleKeys.call.tr(),
                            color: Colors.white,
                            icon: Icons.call,
                            backColor: state.data &&
                                    (widget.model.acceptedReq ?? false)
                                ? AppColors.PRIMARY_COLOR
                                : AppColors.DARK_GRAY_COLOR,
                            onPressed: () {

      ManageVibration.vibrate();
                            },
                            style: Styles.mediumText(
                                fontSize: 18, color: Colors.white),
                          ),
                        ),
                        const Sizer(),
                        Expanded(
                          child: AppButton(
                            label: LocaleKeys.message.tr(),
                            icon: Icons.message,
                            backColor: state.data &&
                                    (widget.model.acceptedReq ?? false)
                                ? AppColors.PRIMARY_COLOR
                                : AppColors.DARK_GRAY_COLOR,
                            style: Styles.mediumText(
                                fontSize: 15, color: Colors.white),
                            onPressed: () {

      ManageVibration.vibrate();
                            },
                          ),
                        ),
                        const Sizer(),
                        Expanded(
                          child: AppButton(
                            label: LocaleKeys.report.tr(),
                            icon: Icons.report,
                            backColor: Colors.red,
                            style: Styles.mediumText(
                                fontSize: 18, color: Colors.white),
                            onPressed: () {
      ManageVibration.vibrate();
                              // tripCubit.report(
                              //     loadingTripId: widget.model.id ?? "");
                              showBottomSheet(
                                context: context,
                                builder: (context) => Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: ReportView(
                                    categoryId: widget.model.categoryId ?? "",
                                    id: widget.model.id ?? "",
                                    loadingTripId: widget.model.id ?? "",
                                  ),
                                ),
                              );
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
      ManageVibration.vibrate();
                              launchUrlString(
                                  "tel://${widget.model.userId?.phone}");
                            },
                            style: Styles.mediumText(
                                fontSize: 18, color: Colors.white),
                          ),
                        ),
                        const Sizer(),
                        Expanded(
                          child: AppButton(
                            label: LocaleKeys.message.tr(),
                            icon: Icons.message,
                            backColor: AppColors.DARK_GRAY_COLOR,
                            style: Styles.mediumText(
                                fontSize: 18, color: Colors.white),
                            onPressed: () {

      ManageVibration.vibrate();
                            },
                          ),
                        ),
                        const Sizer(),
                        Expanded(
                          child: AppButton(
                            label: LocaleKeys.report.tr(),
                            icon: Icons.report,
                            backColor: Colors.red,
                            style: Styles.mediumText(
                                fontSize: 15, color: Colors.white),
                            onPressed: () {
      ManageVibration.vibrate();
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
        ],
      ),
    );
  }
}