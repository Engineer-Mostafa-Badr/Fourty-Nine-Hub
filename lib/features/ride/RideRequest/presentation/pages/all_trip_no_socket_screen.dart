import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/NoSocket/get_all_trip_no_socket_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/NoSocket/send_offer_no_socket_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/change_driver_status_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/trip_offer_card_no_scoket.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/call_message_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../../../../../core/widget/custom_switch_button.dart';
import '../../../../../core/widget/custom_switch_button.dart';
import '../../../../../res/style/styles.dart';

// ignore: must_be_immutable
class AllTripNoSocketScreen extends StatefulWidget {
  const AllTripNoSocketScreen({super.key});

  @override
  State<AllTripNoSocketScreen> createState() => _AllTripNoSocketScreenState();
}

bool? isReady;

class _AllTripNoSocketScreenState extends State<AllTripNoSocketScreen> {
  @override
  void initState() {
    BlocProvider.of<ChangeDriverStatusCubit>(context).getDriverStatus();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      mainCategoryId: 0,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.isArabic ? "مستعد" : "Ready",
                  style: Styles.headerText(fontWeight: FontWeight.w500),
                ),
                BlocListener<ChangeDriverStatusCubit, RiderState>(
                  listener: (context, state) {
                    if (state is SuccessGetDriverStatus) {
                      setState(() {
                        isReady = state.status;
                      });
                    }
                  },
                  child: CustomSwitchButton(
                    // activeTrackColor: AppColors.PRIMARY_COLOR,
                    // inactiveTrackColor: Colors.grey,
                    value: isReady ?? false,
                    onChanged: (value) {
                      setState(() async {
                        await BlocProvider.of<ChangeDriverStatusCubit>(context)
                            .changeDriverStatus();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          BlocListener<SendOfferNoSocketCubit, RiderState>(
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
                            child: TripOfferCardNoScoket(
                              model: e,
                            ));
                      },
                    ).toList(),
                  ));
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
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
