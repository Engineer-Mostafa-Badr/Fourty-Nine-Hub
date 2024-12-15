import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/ride/RideRequest/data/models/create_offer_no_socket_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/NoSocket/get_all_trip_no_socket_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/NoSocket/send_offer_no_socket_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/call_message_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_state.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:url_launcher/url_launcher_string.dart';

// ignore: must_be_immutable
class AllTripNoSocketScreen extends StatelessWidget {
  AllTripNoSocketScreen({super.key});
  TextEditingController price = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      mainCategoryId: 0,
      body: BlocListener<SendOfferNoSocketCubit, RiderState>(
        listener: (context, state) {
          if (state is FailureRiderState) {
            showErrorMessage(
                context, getFailureMessage(state.failure, context));
          }
          if (state is SuccessSendOfferNoSocketState) {
            showSuccessMessage(context, LocaleKeys.successSubmit.tr());
          }
        },
        child: BlocBuilder<GetAllTripNoSocketCubit, RiderState>(
          builder: (context, state) {
            if (state is LoadingRiderState) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.PRIMARY_COLOR,
                ),
              );
            }
            if (state is SuccessGetAllTripNoSocketState) {
              return SingleChildScrollView(
                  child: Column(
                children: state.list.map(
                  (e) {
                    context.read<CallMessageCubit>().getCallMessage(
                        ownerId: e.userId?.id ?? "",
                        subcategoryId: e.categoryId ?? "");
                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 3),
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
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
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white
                                              : AppColors.PRIMARY_COLOR,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          " ${e.status}",
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
                                      '${e.price?.toStringAsFixed(0)}',
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
                                          e.time ?? "",
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
                                    e.passengers.toString(),
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
                                      border: Border.all(
                                          color: Colors.blue, width: 5),
                                      shape: BoxShape.circle),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Expanded(
                                  child: Text(
                                    e.fromTitle ?? "",
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
                                      border: Border.all(
                                          color: Colors.green, width: 5),
                                      shape: BoxShape.circle),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Expanded(
                                  child: Text(
                                    e.toTitle ?? "",
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
                                Row(
                                  children: [
                                    Expanded(
                                      child: AppButton(
                                        style: Styles.mediumText(
                                            fontSize: 28, color: Colors.white),
                                        label: LocaleKeys.sendOffer.tr(),
                                        onPressed: () {
                                          context
                                              .read<SendOfferNoSocketCubit>()
                                              .send(
                                                  tripId: e.id ?? "",
                                                  model:
                                                      CreateOfferNoSocketModel(
                                                          isPremium:
                                                              e.isPremium,
                                                          price: price
                                                                  .text.isEmpty
                                                              ? e.price!
                                                              : double.parse(
                                                                  price.text),
                                                          subcategoryId:
                                                              e.categoryId));
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
                                        hint: e.price.toString(),
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
                                                      (e.acceptedReq ?? false)
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
                                              label: LocaleKeys.message.tr(),
                                              icon: Icons.message,
                                              backColor: state.data &&
                                                      (e.acceptedReq ?? false)
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
                                              label: LocaleKeys.report.tr(),
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
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: ReportView(
                                                      categoryId:
                                                          e.categoryId ?? "",
                                                      id: e.id ?? "",
                                                      loadingTripId: e.id ?? "",
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
                                              backColor:
                                                  AppColors.DARK_GRAY_COLOR,
                                              onPressed: () {
                                                launchUrlString(
                                                    "tel://${e.userId?.phone}");
                                              },
                                              style: Styles.mediumText(
                                                  fontSize: 18,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          const Sizer(),
                                          Expanded(
                                            child: AppButton(
                                              label: LocaleKeys.message.tr(),
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
                                              label: LocaleKeys.report.tr(),
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
                ).toList(),
              ));
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

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
