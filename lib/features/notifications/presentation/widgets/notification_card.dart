import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/zego_uikit_prebuilt_live_streaming.dart';
import 'package:intl/intl.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';

import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/all_trip_model/all_trip_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/call_message_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_state.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/trip_cubit.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../core/data/models/notification_model.dart';
import '../../../../res/assets/assets.dart';

class NotificationCard extends StatelessWidget {
  final NotificationDoc notificationDoc;

  const NotificationCard({super.key, required this.notificationDoc});

  @override
  Widget build(BuildContext context) {
    final DateTime createdAt = DateTime.parse('${notificationDoc.createdAt!}');

    // Convert the time to Egypt timezone (EET or EEST)
    final DateTime egyptTime = createdAt.toUtc().add(const Duration(hours: 3)); // EET is UTC+2, adjust for DST if necessary

    // Format the time for display
    final String formattedTime = DateFormat('h:mm a').format(egyptTime);
    return Container(
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
           SizedBox(
            height: kToolbarHeight,
            width: kToolbarHeight,
            child: Image.asset(Assets.icon,),
          ),
         // const Sizer(),
          Expanded(
            child: Text(
              notificationDoc.bodyTranslationCode!,
              style: Styles.mediumText(),
            ),
          ),
          Column(
            children: [
              IconAppButton(icon: Icons.clear, onPressed: () {}),
              Label(
                text: formattedTime,
                style: Styles.mediumText(color: Colors.grey),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class NotificationDriverCard extends StatefulWidget {
  const NotificationDriverCard(
      {super.key,
      required this.model,
      required this.priceFontSize,
      this.isHistory = false});
  final AllTripModel model;
  final bool isHistory;
  final double priceFontSize;
  @override
  State<NotificationDriverCard> createState() => _NotificationDriverCardState();
}

class _NotificationDriverCardState extends State<NotificationDriverCard> {
  TextEditingController price = TextEditingController();
  PageController controller = PageController();
  @override
  void initState() {
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
          showSuccessMessage(context, 'you have reported this trip.');
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () {},
          child: Container(
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
                    Row(
                      children: [
                        if (!widget.isHistory)
                          const Text(
                            'New Ride ',
                            style: TextStyle(
                              color: AppColors.PRIMARY_COLOR,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        Text(
                          widget.isHistory ? '${widget.model.status}' : '(status)',
                          // ignore: prefer_const_constructors
                          style: TextStyle(
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
                        const Text("Premium")
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
                          Icon(Icons.calendar_month),
                          Flexible(
                            child: Text(
                              "${5} August, 09:47",
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
                      width: 6,
                    ),
                    Text(
                      widget.model.desc ?? "",
                      style: const TextStyle(fontSize: 12),
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
                const SizedBox(height: 5),
                widget.isHistory
                    ? Row(
                        children: [
                          Flexible(
                            child: AppButton(
                              width: double.infinity,
                              onPressed: () {},
                              label: "Tripi rating",
                              backColor: Colors.orange,
                              style: Styles.mediumText(
                                  fontSize: 18, color: Colors.white),
                            ),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Flexible(
                            child: AppButton(
                              width: double.infinity,
                              onPressed: () {},
                              label: "Modify trip",
                              style: Styles.mediumText(
                                  fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ],
                      )
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
                                      fontSize: 18, color: Colors.white),
                                  label: "Send Offer",
                                  onPressed: () {
                                    tripCubit.newOffer(
                                        id: widget.model.id ?? "",
                                        price: widget.model.price ?? 0,
                                        message:
                                            "The request has been successfully approved.");
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
                                        label: Labels.call,
                                        color: Colors.white,
                                        icon: Icons.call,
                                        backColor: state.data
                                            ? AppColors.PRIMARY_COLOR
                                            : AppColors.DARK_GRAY_COLOR,
                                        onPressed: () {},
                                        style: Styles.mediumText(
                                            fontSize: 18, color: Colors.white),
                                      ),
                                    ),
                                    const Sizer(),
                                    Expanded(
                                      child: AppButton(
                                        label: Labels.message,
                                        icon: Icons.message,
                                        backColor: state.data
                                            ? AppColors.PRIMARY_COLOR
                                            : AppColors.DARK_GRAY_COLOR,
                                        style: Styles.mediumText(
                                            fontSize: 15, color: Colors.white),
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
                                            fontSize: 18, color: Colors.white),
                                        onPressed: () {
                                          // tripCubit.report(
                                          //     loadingTripId: widget.model.id ?? "");
                                          showBottomSheet(
                                            context: context,
                                            builder: (context) => Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: ReportView(
                                                categoryId:
                                                    widget.model.categoryId ??
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
                                        backColor: AppColors.DARK_GRAY_COLOR,
                                        onPressed: () {
                                          launchUrlString("tel://21213123123");
                                        },
                                        style: Styles.mediumText(
                                            fontSize: 18, color: Colors.white),
                                      ),
                                    ),
                                    const Sizer(),
                                    Expanded(
                                      child: AppButton(
                                        label: Labels.message,
                                        icon: Icons.message,
                                        backColor: AppColors.DARK_GRAY_COLOR,
                                        style: Styles.mediumText(
                                            fontSize: 18, color: Colors.white),
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
                                          color: Colors.white,
                                        ),
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
  String getMonthName(int month) {
  List<String> monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  // للتحقق من أن رقم الشهر في النطاق الصحيح
  if (month < 1 || month > 12) {
    return 'Invalid month';
  }

  return monthNames[month - 1];
}
}
