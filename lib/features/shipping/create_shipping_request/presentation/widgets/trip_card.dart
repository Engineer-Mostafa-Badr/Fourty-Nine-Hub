import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/lang_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/all_trip_model/all_trip_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/accept_decline_trip_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/call_message_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_state.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/trip_cubit.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';

class TripCardWidget extends StatefulWidget {
  const TripCardWidget(
      {super.key,
      required this.model,
      this.yourRequest = false,
      this.padding,
      this.margin,
      this.buttons = false,
      this.title,
      this.noBoardr = false,
      this.noBracts = false,
      this.priceFontSize = 22});
  final AllTripModel model;
  final bool buttons;
  final double priceFontSize;
  final bool yourRequest;
  final String? title;
  final bool noBoardr;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool noBracts;
  @override
  State<TripCardWidget> createState() => _TripCardWidgetState();
}

class _TripCardWidgetState extends State<TripCardWidget> {
  TextEditingController price = TextEditingController();
  PageController controller = PageController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    price.text = widget.model.price?.toStringAsFixed(0) ?? "0";
    context.read<CallMessageCubit>().getCallMessage(
        ownerId: widget.model.userId ?? "",
        subcategoryId: widget.model.categoryId ?? "");
  }

  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    var tripCubit = context.read<TripCubit>();
    return BlocConsumer<TripCubit, ShippingState>(
      listener: (context, state) {
        if (state is SuccessAcceptOfferState) {
          showSuccessMessage(context, state.message);
        }
        if (state is SuccessSendNewOfferState) {
          context.pop();
          showSuccessMessage(context, state.message);
        }
        if (state is SuccessAcceptPremiumOfferState) {
          showSuccessMessage(context, state.message);
        }
        if (state is FailureShippingState) {
          showErrorMessage(context, getFailureMessage(state.failure, context));
        }
        if (state is SuccessReportState) {
          showSuccessMessage(context, 'you have reported this trip.'.tr());
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            if (!widget.buttons && !widget.yourRequest) {
              context.push(Routes.DRIVERREQUESTSDETIALS, extra: widget.model);
            }
          },
          child: Container(
            margin: widget.margin ??
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
                border: widget.noBoardr
                    ? null
                    : Border.all(color: Colors.black, width: 3),
                borderRadius: BorderRadius.circular(10)),
            padding: widget.padding ??
                const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.title ?? 'New Ride'.tr(),
                          style: const TextStyle(
                            color: AppColors.PRIMARY_COLOR,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        Text(
                          widget.noBracts
                              ? " ${widget.model.status}"
                              : " (${widget.model.status})",
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '${widget.model.price?.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: widget.priceFontSize,
                          ),
                        ),
                        if (!widget.noBracts) Text("Premium".tr())
                      ],
                    ),
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.calendar_month),
                          Flexible(
                            child: Text(
                              "25 August, 09:47",
                              style: TextStyle(fontSize: 13),
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
                    const Icon(Icons.chat),
                    const SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      child: Text(
                        widget.model.desc ?? "",
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
                        widget.model.startLocation ?? "",
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
                        widget.model.targetLocation ?? "",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                const SizedBox(height: 10),
                widget.yourRequest
                    ? AppButton(
                        width: double.infinity,
                        height: 50,
                        // padding: EdgeInsets.symmetric(vertical: 0),
                        color: Colors.white,
                        backColor: AppColors.PRIMARY_COLOR,
                        onPressed: () {
                          log(widget.model.id.toString(),
                              name: "lksdjfklsdjfkf");
                          context
                              .read<AcceptDeclineTripCubit>()
                              .cancel(tripId: widget.model.id ?? "");
                        },
                        label: "Cancel Request".tr(),
                      )
                    : widget.buttons
                        ? Container()
                        : Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: AppButton(
                                      style: Styles.mediumText(
                                          fontSize: 28, color: Colors.white),
                                      label: "Send Offer".tr(),
                                      onPressed: () {
                                        tripCubit.newOffer(
                                            id: widget.model.id ?? "",
                                            price: widget.model.price ?? 0,
                                            message:
                                                "The request has been successfully approved.".tr());
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
                                      constraints: const BoxConstraints(
                                        maxHeight: kToolbarHeight * .6,
                                        minHeight: kToolbarHeight * .6,
                                      ),
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
                                  if (state is FailureShippingState) {
                                    log(
                                        getFailureMessage(
                                            state.failure, context),
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
                                            label: Labels.call,
                                            color: Colors.white,
                                            icon: Icons.call,
                                            backColor: state.data &&
                                                    (widget.model.acceptedReq ??
                                                        false)
                                                ? AppColors.PRIMARY_COLOR
                                                : AppColors.DARK_GRAY_COLOR,
                                            onPressed: () {},
                                            style: Styles.mediumText(
                                                fontSize: 18,
                                                color: Colors.white),
                                          ),
                                        ),
                                        const Sizer(),
                                        Expanded(
                                          child: AppButton(
                                            label: Labels.message,
                                            icon: Icons.message,
                                            backColor: state.data &&
                                                    (widget.model.acceptedReq ??
                                                        false)
                                                ? AppColors.PRIMARY_COLOR
                                                : AppColors.DARK_GRAY_COLOR,
                                            style: Styles.mediumText(
                                                fontSize: 15,
                                                color: Colors.white),
                                            onPressed: () {},
                                          ),
                                        ),
                                        const Sizer(),
                                        Expanded(
                                          child: AppButton(
                                            label: Labels.report,
                                            icon: Icons.report,
                                            backColor: Colors.red,
                                            style: Styles.mediumText(
                                                fontSize: 18,
                                                color: Colors.white),
                                            onPressed: () {
                                              // tripCubit.report(
                                              //     loadingTripId: widget.model.id ?? "");
                                              showBottomSheet(
                                                context: context,
                                                builder: (context) => Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: ReportView(
                                                    categoryId: widget
                                                            .model.categoryId ??
                                                        "",
                                                    id: widget.model.id ?? "",
                                                    loadingTripId:
                                                        widget.model.id ?? "",
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
                                            label: Labels.call,
                                            color: Colors.white,
                                            icon: Icons.call,
                                            backColor:
                                                AppColors.DARK_GRAY_COLOR,
                                            onPressed: () {
                                              launchUrlString(
                                                  "tel://21213123123");
                                            },
                                            style: Styles.mediumText(
                                                fontSize: 18,
                                                color: Colors.white),
                                          ),
                                        ),
                                        const Sizer(),
                                        Expanded(
                                          child: AppButton(
                                            label: Labels.message,
                                            icon: Icons.message,
                                            backColor:
                                                AppColors.DARK_GRAY_COLOR,
                                            style: Styles.mediumText(
                                                fontSize: 18,
                                                color: Colors.white),
                                            onPressed: () {},
                                          ),
                                        ),
                                        const Sizer(),
                                        Expanded(
                                          child: AppButton(
                                            label: Labels.report,
                                            icon: Icons.report,
                                            backColor: Colors.red,
                                            style: Styles.mediumText(
                                                fontSize: 15,
                                                color: Colors.white),
                                            onPressed: () {
                                              showBottomSheet(
                                                context: context,
                                                builder: (context) =>
                                                    const ReportView(
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
          ),
        );
      },
    );
  }
}
