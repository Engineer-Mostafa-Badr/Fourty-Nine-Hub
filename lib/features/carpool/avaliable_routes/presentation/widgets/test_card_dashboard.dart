import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/domain/entities/get_all_trips_entity.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/cubits/accept_trip/cubit/accept_trip_for_driver_cubit.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/cubits/get_currency/cubit/get_currency_cubit.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/widgets/address_info_list.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/widgets/available_rotes_bar_info.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/views/widgets/card.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/available_trip_button.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

class TestCardDashboard extends StatelessWidget {
  const TestCardDashboard({super.key, required this.entity});
  final CarpoolTripParam entity;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AcceptTripForDriverCubit(serviceLocator()),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomCard(
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
              AvilableRoutesBarInfo(entity: entity),
              const Sizer(),
              AddressInfoList(entity: entity),
              const Sizer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DateTime.now()
                              .difference(
                                  DateTime.parse(entity.createdAt.toString()))
                              .inMinutes <
                          60
                      ? Text(
                          "  ${DateTime.now().difference(DateTime.parse(entity.createdAt.toString())).inMinutes} ${LocaleKeys.minutesAgo.localize}",
                          style: Styles.headerText(fontSize: 24))
                      : DateTime.now()
                                  .difference(DateTime.parse(
                                      entity.createdAt.toString()))
                                  .inMinutes <
                              1440
                          ? Text(
                              "  ${DateTime.now().difference(DateTime.parse(entity.createdAt.toString())).inHours} ${LocaleKeys.hoursAgo.localize}",
                              style: Styles.headerText(fontSize: 24))
                          : Text(
                              "  ${DateTime.now().difference(DateTime.parse(entity.createdAt.toString())).inDays} ${LocaleKeys.daysAgo.localize}",
                              style: Styles.headerText(fontSize: 24)),
                  const Spacer(),
                  Text(
                      entity.womenOnly == true
                          ? LocaleKeys.womenOnly.localize
                          : '',
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
                    child: Stack(
                      children: [
                        AvaialbleTripsButton(
                          title: LocaleKeys.Accept.localize,
                          color: AppColors.PRIMARY_COLOR,
                          onTap: () {
                            BlocProvider.of<AcceptTripForDriverCubit>(context)
                                .acceptTripForDriver(tripId: entity.id);
                          },
                        ),
                        Positioned.directional(
                          top: 0,
                          end: 20,
                          textDirection: context.isArabic
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          child: SizedBox(
                            height: 80.0,
                            width: 20,
                            child: BlocBuilder<AcceptTripForDriverCubit,
                                AcceptTripForDriverState>(
                              builder: (context, state) {
                                if (state is AcceptTripForDriverLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.white),
                                  );
                                }
                                if (state is AcceptTripForDriverSuccess) {
                                  return Center(
                                    child: Icon(Icons.check,
                                        color: Colors.green[400], size: 30),
                                  );
                                }
                                if (state is AcceptTripForDriverFailure) {
                                  return Center(
                                    child: Icon(Icons.error,
                                        color: Colors.red[400], size: 30),
                                  );
                                }
                                return const SizedBox();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Sizer(),
            ],
          ),
        ],
      ),
    );
  }
}
