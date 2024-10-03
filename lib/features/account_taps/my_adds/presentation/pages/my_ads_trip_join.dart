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
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/enums/wallet_types_enums.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../subscripe/presentation/controllers/subscription_controller.dart';
import '../../domain/entity/docs_trip_join_entity.dart';
import '../../domain/usecases/get_all_counts_usecase.dart';
import '../cubit/my_adds_cubit.dart';
import '../widgets/custom_button_count.dart';

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
                      Text('${tripJoinCardEntity.passengers} ${LocaleKeys.seat.localize}', style: Styles.headerText()),
                      const Spacer(),
                      Visibility(
                        visible: tripJoinCardEntity.isRepeat,
                        child: Icon(
                          (tripJoinCardEntity.isRepeat) ? Icons.check_box : Icons.check_box_outline_blank,
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
                      const Icon(Icons.trip_origin, color: AppColors.LIGHT_BLUE, size: 20),
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
                      const Icon(Icons.trip_origin, color: AppColors.CHECK_MARK_COLOR, size: 20),
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
                  _buildContactInfo(context),
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
                            serviceLocator<SubscriptionController>().showSubscriptionPlans(
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
                                context.read<MyAddsCubit>().deleteMyTripJoin(id: tripJoinCardEntity.id);
                              },
                              context: context,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned.directional(
                top: 5,
                end: 20,
                textDirection: context.isArabic ? TextDirection.rtl : TextDirection.ltr,
                child: Column(
                  children: [
                    Text(tripJoinCardEntity.price.toStringAsFixed(0),
                        style: Styles.headerText(fontSize: 70, color: Colors.green[600])),
                    Text(tripJoinCardEntity.status,
                        style: Styles.headerText(fontSize: 30, color: AppColors.SECONDARY_COLOR)),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate() {
    return intl.DateFormat('dd MMM, hh:mm aaa').format(DateTime.fromMicrosecondsSinceEpoch(tripJoinCardEntity.time));
  }

  Widget _buildContactInfo(context) {
    return BlocProvider<MyAddsCubit>(
      create: (BuildContext context) =>
          serviceLocator()..getAllCount(params: Params(id: tripJoinCardEntity.id, status: 'chat')),
      child: BlocBuilder<MyAddsCubit, MyAddsState>(
        builder: (BuildContext context, state) {
          return Row(
            children: [
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomButtonCount(
                          id: tripJoinCardEntity.id,
                          status: 'call',
                        ),
                      ));
                },
                child: _buildContactItem(
                    icon: Icons.call_outlined,
                    label: LocaleKeys.tel.localize,
                    value: state.allCounts?.length ?? 0,
                    context: context),
              )),
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomButtonCount(
                          id: tripJoinCardEntity.id,
                          status: 'chat',
                        ),
                      ));
                },
                child: _buildContactItem(
                    icon: Icons.chat_bubble_outline,
                    label: LocaleKeys.chats.localize,
                    value: state.allCounts?.length ?? 0,
                    context: context),
              )),
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomButtonCount(
                          id: tripJoinCardEntity.id,
                          status: 'like',
                        ),
                      ));
                },
                child: _buildContactItem(
                    icon: Icons.favorite_border_outlined,
                    label: LocaleKeys.like.localize,
                    value: state.allCounts?.length ?? 0,
                    context: context),
              )),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContactItem({required IconData icon, required String label, required int value, required context}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Theme.of(context).primaryColor,
          ),
          child: Icon(
            icon,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
        const Sizer(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(
                text: '$value',
                style: Styles.mediumText(fontSize: 22),
              ),
              Label(
                text: label,
                style: Styles.mediumText(fontSize: 26),
              ),
            ],
          ),
        )
      ],
    );
  }
}
