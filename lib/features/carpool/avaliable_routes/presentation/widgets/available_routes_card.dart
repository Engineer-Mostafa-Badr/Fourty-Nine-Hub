import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/domain/entities/available_routes_card_entity.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/domain/entities/get_all_trips_entity.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/cubits/cubit/get_all_trips_cubit.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/cubits/cubit/get_all_trips_state.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/cubits/cubit/get_all_trips_state.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/cubits/get_currency/cubit/get_currency_cubit.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/widgets/address_info_list.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/widgets/available_rotes_bar_info.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/views/widgets/card.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../cubits/get_currency/cubit/get_currency_cubit.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

class AvaiableRoutesCard extends StatefulWidget {
  const AvaiableRoutesCard({
    super.key,
    required this.entity,
  });
  final CarpoolTripParam entity;

  @override
  State<AvaiableRoutesCard> createState() => _AvaiableRoutesCardState();
}

class _AvaiableRoutesCardState extends State<AvaiableRoutesCard> {
  DateTime? createdAt;
  late final GetCurrencyCubit getCurrencyCubit;

  @override
  void initState() {
    getCurrencyCubit = context.read<GetCurrencyCubit>()..getCurrencyData();
    final userId = serviceLocator<UserCubit>().state.data?.id ?? '';

    print(userId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: BlocBuilder<GetAllTripsCubit, GetAllTripsState>(
        builder: (context, state) {
          return CustomCard(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Text("40:00:00",
                  //     style: Styles.smallText(
                  //         color: AppColors.SECONDARY_COLOR,
                  //         fontWeight: FontWeight.w600)),
                  // SizedBox(
                  //   width: 24,
                  // ),
                  widget.entity.comfort
                      ? Text(LocaleKeys.comfort.localize,
                          style: Styles.mediumText(
                              color: AppColors.PRIMARY_COLOR,
                              fontWeight: FontWeight.w600))
                      : const SizedBox(),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text('${widget.entity.priceForEveryUser} ',
                              style: Styles.headerText(
                                  fontSize: 36,
                                  color: AppColors.CHECK_MARK_COLOR,
                                  fontWeight: FontWeight.w600)),
                          BlocBuilder<GetCurrencyCubit, GetCurrencyState>(
                            builder: (context, state) {
                              //   if (state is GetCurrencySuccess) {
                              //     return Text(" ${state.currency}",
                              //         style: Styles.headerText(
                              //           fontSize: 22,
                              //           color: AppColors.SECONDARY_COLOR,
                              //         ));
                              //   } else {
                              //     return Text("",
                              //         style: Styles.headerText(
                              //           fontSize: 22,
                              //           color: AppColors.SECONDARY_COLOR,
                              //         ));
                              //   }

                              return Text(
                                BlocProvider.of<GetCurrencyCubit>(context)
                                    .currency,
                                style: Styles.mediumText(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.SECONDARY_COLOR),
                              );
                            },
                          ),
                        ],
                      ),
                      Text(LocaleKeys.seat.localize,
                          style: Styles.mediumText(
                            color: AppColors.PRIMARY_COLOR,
                          )),
                    ],
                  ),
                ],
              ),
              AvilableRoutesBarInfo(entity: widget.entity),
              const Sizer(),
              AddressInfoList(entity: widget.entity),
              const Sizer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                      "  ${DateTime.now().difference(DateTime.parse(widget.entity.createdAt.toString())).inMinutes} ${LocaleKeys.minutesAgo.localize}",
                      style: Styles.headerText(fontSize: 24)),
                  const Spacer(),
                  Text(
                      widget.entity.womenOnly == true
                          ? LocaleKeys.womenOnly.localize
                          : '',
                      style: Styles.headerText(
                          fontSize: 24, color: AppColors.SECONDARY_COLOR)),
                ],
              ),
              const Sizer(),
            ],
          );
        },
      ),
    );
  }
}
