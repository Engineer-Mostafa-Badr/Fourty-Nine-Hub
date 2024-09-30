import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/views/widgets/card.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/available_trip_button.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../../common/widgets/stateless/dynamic/are_you_sure.dart';
import '../../../../../core/enums/wallet_types_enums.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../subscripe/presentation/controllers/subscription_controller.dart';
import '../../domain/entity/docs_trip_join_entity.dart';
import '../cubit/my_adds_cubit.dart';

class MyAdsTripJoin extends StatelessWidget {
  const MyAdsTripJoin({
    super.key,
    required this.tripJoinCardEntity,
  });

  final DocsTripJoinEntity tripJoinCardEntity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              CustomCard(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.time_to_leave),
                      const Sizer(),
                      Text(
                        '${tripJoinCardEntity.vehicleId.brand}, ${tripJoinCardEntity.vehicleId.model}',
                        style: Styles.headerText(
                          fontSize: 45,
                          color: AppColors.SECONDARY_COLOR,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                  const Sizer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.calendar_month),
                      const Sizer(),
                      Text(_formatDate(), style: Styles.headerText()),
                    ],
                  ),
                  const Sizer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.airline_seat_recline_extra_rounded),
                      const Sizer(),
                      Text('${tripJoinCardEntity.passengers} ${LocaleKeys.seat.localize}',
                          style: Styles.headerText()),
                      const Spacer(),
                      Visibility(
                        visible: tripJoinCardEntity.isRepeat,
                        child: Icon(
                          (tripJoinCardEntity.isRepeat)
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: AppColors.PRIMARY_COLOR,
                        ),
                      ),
                      const Sizer(),
                      Visibility(
                        visible: tripJoinCardEntity.isRepeat,
                        child: Text(LocaleKeys.repeated.localize, style: Styles.headerText()),
                      ),
                      const Sizer(width: 20),
                    ],
                  ),
                  const Sizer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.trip_origin,
                          color: AppColors.LIGHT_BLUE, size: 20),
                      const Sizer(width: 13),
                      Flexible(
                        child: Text(
                          tripJoinCardEntity.fromEn,
                          style: Styles.headerText(fontSize: 32),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  const Sizer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.trip_origin,
                          color: AppColors.CHECK_MARK_COLOR, size: 20),
                      const Sizer(width: 13),
                      Flexible(
                        child: Text(
                          tripJoinCardEntity.toAr,
                          style: Styles.headerText(fontSize: 32),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  const Sizer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3,
                        child: AvaialbleTripsButton(
                          title: LocaleKeys.subscription.localize,
                          color: AppColors.PRIMARY_COLOR,
                          onTap: () {
                            serviceLocator<SubscriptionController>()
                                .showSubscriptionPlans(
                              wallets: [
                                WalletTypes.mainWallet,
                                WalletTypes.giftWallet,
                                WalletTypes.balance,
                              ],
                              subCategoryId: tripJoinCardEntity.categoryId.id,
                              title: LocaleKeys.tripJoinAds.localize,
                            );
                          },
                        ),
                      ),
                      const Sizer(width: 5),
                      Expanded(
                        flex: 3,
                        child: AvaialbleTripsButton(
                          title: LocaleKeys.deleteAd.localize,
                          color: AppColors.SECONDARY_COLOR,
                          onTap: () {
                            showAreYouSure(
                              title: LocaleKeys.deleteAd.localize,
                              subTitle: LocaleKeys.sureRemoveAd.localize,
                              action: () {
                                context.read<MyAddsCubit>().deleteMyTripJoin(
                                    id: tripJoinCardEntity.id);
                              },
                              context: context,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  // const Sizer(),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   children: [
                  //     Expanded(
                  //       flex: 3,
                  //       child: AvaialbleTripsButton(
                  //         title: 'Call',
                  //         color:  AppColors.DARK_GRAY_COLOR,
                  //         // color: (tripJoinCardEntity.isApproved ?? false)
                  //         //     ? AppColors.PRIMARY_COLOR
                  //         //     : AppColors.DARK_GRAY_COLOR,
                  //         icon: Icons.call,
                  //         onTap: callOnTap,
                  //       ),
                  //     ),
                  //     const Sizer(width: 5),
                  //     Expanded(
                  //       flex: 3,
                  //       child: AvaialbleTripsButton(
                  //         title: 'Message',
                  //         color: AppColors.DARK_GRAY_COLOR,
                  //         // color: (tripJoinCardEntity.isApproved ?? false)
                  //         //     ? AppColors.PRIMARY_COLOR
                  //         //     : AppColors.DARK_GRAY_COLOR,
                  //         icon: Icons.email,
                  //         onTap: messageOnTap,
                  //       ),
                  //     ),
                  //     const Sizer(width: 5),
                  //     Expanded(
                  //       flex: 3,
                  //       child: AvaialbleTripsButton(
                  //         title: 'Report',
                  //         color: AppColors.SECONDARY_COLOR,
                  //         icon: Icons.report,
                  //         onTap: reportOnTap,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
              Positioned.directional(
                top: 5,
                end: 20,
                textDirection:
                    context.isArabic ? TextDirection.rtl : TextDirection.ltr,
                child: Column(
                  children: [
                    Text(tripJoinCardEntity.price.toStringAsFixed(0),
                        style: Styles.headerText(
                            fontSize: 70, color: Colors.green[600])),
                    Text(tripJoinCardEntity.status,
                        style: Styles.headerText(
                            fontSize: 30, color: AppColors.SECONDARY_COLOR)),
                  ],
                ),
              )
            ],
          ),
          // const Sizer(),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 10),
          //   child: InkWell(
          //     onTap: subscribeMessageOnTap,
          //     child: Text(
          //       'Subscribe to contact the client!',
          //       style: Styles.headerText(
          //         color: Colors.red[300],
          //         fontSize: 30,
          //       ),
          //       textAlign: TextAlign.start,
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  String _formatDate() {
    return intl.DateFormat('dd MMM, hh:mm aaa')
        .format(DateTime.fromMicrosecondsSinceEpoch(tripJoinCardEntity.time));
  }
}
